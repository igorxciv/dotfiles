# Custom kitty tab bar — normal powerline tabs on the LEFT, and a right-aligned
# status strip of COLORED, ARROW-SEPARATED segments (date · clock).
#
# ACTIVATION: does nothing until `tab_bar_style custom` is set in ui.conf.
#             kitty auto-loads a file named tab_bar.py from the config dir.
# FONT: needs powerline/Nerd Font glyphs (Agave Nerd Font Mono).
#
# CUSTOMIZE: edit the color constants below, swap LEFT_SEP for a different arrow
# shape, or add/reorder entries in SEGMENTS (each needs a text producer + fg/bg).

import datetime

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_tab_with_powerline,
)

# LEFT-pointing powerline arrow between segments.
# alternatives: "" angled   "" slanted   "" rounded
LEFT_SEP = ""

# Colors (hex). BAR_BG must match tab_bar_background in ui.conf.
BAR_BG = "191925"
FG_LIGHT = "ebddd7"
FG_DARK = "191925"
SEG_BG = "393a4d"

# Redraw timer so the clock actually ticks.
_timer_id = None


def _redraw_tab_bar(_tid: int) -> None:
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


# Widget text producers (return "" to hide that segment).
def _date() -> str:
    return f"{datetime.datetime.now():%a %-d %b}"


def _clock() -> str:
    return f"{datetime.datetime.now():%-I:%M %p}"


# Segments: ordered LEFT → RIGHT.
SEGMENTS = [
    {"text": _date,  "fg": FG_LIGHT, "bg": SEG_BG},
    {"text": _clock, "fg": FG_DARK,  "bg": FG_LIGHT},
]


def _rgb(h: str) -> int:
    return as_rgb(int(h, 16))


def _draw_right_status(screen: Screen) -> None:
    cells = []
    for seg in SEGMENTS:
        t = seg["text"]()
        if t:
            cells.append((f" {t} ", seg["fg"], seg["bg"]))
    if not cells:
        return

    # total width = every segment's text + one separator arrow each
    width = sum(len(t) for t, _, _ in cells) + len(cells)
    right_x = screen.columns - width
    if screen.cursor.x > right_x:
        return  # tabs already fill the bar — don't clobber titles

    screen.cursor.x = right_x
    prev_bg = BAR_BG
    for text, fg, bg in cells:
        # arrow: colored as THIS segment's bg, drawn over the PREVIOUS bg
        screen.cursor.fg = _rgb(bg)
        screen.cursor.bg = _rgb(prev_bg)
        screen.draw(LEFT_SEP)
        # segment body: fg text on its bg
        screen.cursor.fg = _rgb(fg)
        screen.cursor.bg = _rgb(bg)
        screen.draw(text)
        prev_bg = bg
    screen.cursor.bg = _rgb(BAR_BG)  # reset so nothing bleeds past the edge


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global _timer_id
    if _timer_id is None:
        _timer_id = add_timer(_redraw_tab_bar, 2.0, True)

    end = draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    if is_last:
        _draw_right_status(screen)
    return end
