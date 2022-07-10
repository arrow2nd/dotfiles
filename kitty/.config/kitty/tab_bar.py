# pyright: reportMissingImports=false
# https://github.com/kovidgoyal/kitty/discussions/4447#discussion-3781380

import datetime
import subprocess

from decimal import Decimal, ROUND_HALF_UP

from kitty.fast_data_types import Screen
from kitty.rgb import Color
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int


def calc_draw_spaces(*args) -> int:
    length = 0
    for i in args:
        if not isinstance(i, str):
            i = str(i)
        length += len(i)
    return length


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if draw_data.leading_spaces:
        screen.draw(" " * draw_data.leading_spaces)

    draw_title(draw_data, screen, tab, index)

    trailing_spaces = min(max_title_length - 1, draw_data.trailing_spaces)
    max_title_length -= trailing_spaces

    extra = screen.cursor.x - before - max_title_length
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw("…")
    
    if trailing_spaces:
        screen.draw(" " * trailing_spaces)

    end = screen.cursor.x

    screen.cursor.bold = screen.cursor.italic = False
    screen.cursor.fg = 0

    if not is_last:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
        screen.draw(draw_data.sep)

    screen.cursor.bg = 0
    return end


def _get_battery_status(default: Color) -> tuple[Color, str]:
    warn = Color(249, 213, 117)
    danger = Color(212, 128, 126)

    # バッテリー残量を取得
    try:
        batt = int(subprocess.getoutput("pmset -g batt | grep -Eo \"\d+%\" | cut -d% -f1"))
    except Exception:
        return danger, " unknown "

    # 残量から表示色を決定
    color = default
    if batt <= 15:
        color = danger
    elif batt <= 20:
        color = warn

    # 残量に合ったアイコンを選択
    i = int(Decimal(batt).quantize(Decimal('1E1'), rounding=ROUND_HALF_UP)) // 10

    return color, f"{''[i]} {batt}% "


def _draw_right_status(screen: Screen, is_last: bool) -> int:
    if not is_last:
        return

    cells = [
        (Color(161, 125, 101), " "),
        _get_battery_status(Color(81, 86, 103)),
        (Color(81, 86, 103), datetime.datetime.now().strftime(" %H:%M ")),
    ]

    right_status_length = calc_draw_spaces(''.join([e for _, e in cells]))

    draw_spaces = screen.columns - screen.cursor.x - right_status_length
    if draw_spaces > 0:
        screen.draw(" " * draw_spaces)

    screen.cursor.fg = 0
    for color, status in cells:
        screen.cursor.fg = as_rgb(color_as_int(color))
        screen.draw(status)
    screen.cursor.bg = 0

    if screen.columns - screen.cursor.x > right_status_length:
        screen.cursor.x = screen.columns - right_status_length

    return screen.cursor.x


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
    _draw_left_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )

    _draw_right_status(
        screen,
        is_last,
    )

    return screen.cursor.x
