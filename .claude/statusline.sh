#!/usr/bin/env bash
# Claude Code status line — two-line dashboard.
# Reads the session JSON payload on stdin; payload-only (no transcript parsing),
# so it does not break when Claude Code updates. ~40ms per render.

in=$(cat)
IFS=$'\x1f' read -r MODEL EFFORT FAST DIR CWD WT AGENT PCT TOKENS WIN COST ADD DEL MINS FIVEH FIVEH_RESET SEVEND SEVEND_RESET < <(
  printf '%s' "$in" | jq -r '[
    (.model.display_name | sub(" \\(.*\\)$";"")),
    (.effort.level // "-"),
    (if .fast_mode then "1" else "0" end),
    (.workspace.current_dir | split("/") | last),
    (.workspace.current_dir),
    (.workspace.git_worktree // .worktree.name // ""),
    (.agent.name // ""),
    (.context_window.used_percentage // 0 | floor),
    (((.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)) / 1000 | floor),
    ((.context_window.context_window_size // 200000) / 1000 | floor),
    (.cost.total_cost_usd // 0),
    (.cost.total_lines_added // 0),
    (.cost.total_lines_removed // 0),
    ((.cost.total_duration_ms // 0) / 60000 | floor),
    (.rate_limits.five_hour.used_percentage // -1 | floor),
    (.rate_limits.five_hour.resets_at // 0 | floor),
    (.rate_limits.seven_day.used_percentage // -1 | floor),
    (.rate_limits.seven_day.resets_at // 0 | floor)
  ] | map(tostring) | join("")'
)

R=$'\e[0m'; D=$'\e[2m'; B=$'\e[1m'
BLU=$'\e[38;5;110m'; GRN=$'\e[38;5;108m'; YLW=$'\e[38;5;179m'
RED=$'\e[38;5;174m'; MAG=$'\e[38;5;139m'; CYN=$'\e[38;5;109m'

if   (( PCT >= 80 )); then C=$RED
elif (( PCT >= 55 )); then C=$YLW
else                       C=$GRN
fi

FILL=$(( (PCT + 5) / 10 )); BAR=""
for ((i = 0; i < 10; i++)); do (( i < FILL )) && BAR+="█" || BAR+="░"; done
DOT="${D}·${R}"

# ── line 1: what am I, where am I ──────────────────────────────────────────
l1="${B}${BLU}${MODEL}${R}${D} ${EFFORT}${R}"
[[ $FAST == 1 ]] && l1+=" ${YLW}⚡${R}"
[[ -n $AGENT ]] && l1+="  ${D}${R} ${CYN}${AGENT}${R}"
l1+="  ${D}${R} ${DIR}"

BR=$(git -C "$CWD" branch --show-current 2>/dev/null)
if [[ -n $BR ]]; then
    git -C "$CWD" diff --quiet 2>/dev/null &&
    git -C "$CWD" diff --cached --quiet 2>/dev/null || BR+=" ${YLW}●${R}"
    l1+="  ${D}${R} ${MAG}${BR}${R}"
fi
[[ -n $WT ]] && l1+="  ${D}${R} ${D}${WT}${R}"

# ── line 2: what is this session costing me ───────────────────────────────
WINL=$([ "$WIN" -ge 1000 ] && echo "$((WIN / 1000))M" || echo "${WIN}k")
l2="${C}${BAR}${R} ${C}${PCT}%${R} ${D}${TOKENS}k/${WINL}${R}"
l2+="  ${DOT} \$$(printf '%.2f' "$COST")"
l2+="  ${DOT} ${GRN}+${ADD}${R}${D}/${R}${RED}-${DEL}${R}"
# Rate limits stay quiet until they matter: dim -> amber at 60% -> red at 85%.
limit_color() {
    if   (( $1 >= 85 )); then printf '%s' "$RED"
    elif (( $1 >= 60 )); then printf '%s' "$YLW"
    else                      printf '%s' "$D"
    fi
}
if (( FIVEH >= 0 )); then
    l2+="  ${DOT} $(limit_color "$FIVEH")5h ${FIVEH}%${R}"
    # The 5h window is short enough that minutes are the unit that matters.
    if (( FIVEH_RESET > 0 )); then
        LEFT=$(( FIVEH_RESET - $(date +%s) ))
        if (( LEFT > 0 )); then
            l2+="${D} ↻$(( LEFT / 3600 ))h$(printf '%02d' $(( LEFT % 3600 / 60 )))m${R}"
        fi
    fi
fi
if (( SEVEND >= 0 )); then
    l2+="  ${DOT} $(limit_color "$SEVEND")7d ${SEVEND}%${R}"
    # Weekly quota is the one worth pacing against, so show when it refills.
    if (( SEVEND_RESET > 0 )); then
        LEFT=$(( SEVEND_RESET - $(date +%s) ))
        if   (( LEFT > 86400 )); then l2+="${D} ↻$(( LEFT / 86400 ))d${R}"
        elif (( LEFT > 0 ));     then l2+="${D} ↻$(( LEFT / 3600 ))h${R}"
        fi
    fi
fi
l2+="  ${DOT} ${D}${MINS}m${R}"

printf '%s\n%s\n' "$l1" "$l2"
