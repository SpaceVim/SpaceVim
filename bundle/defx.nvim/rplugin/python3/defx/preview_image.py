import ueberzug.lib.v0 as ueberzug
import sys
import time

if __name__ == '__main__' and len(sys.argv) > 3:
    with ueberzug.Canvas() as c:
        total_width = int(sys.argv[2])
        preview_width = int(sys.argv[3])
        ratio = preview_width / total_width
        width = preview_width

        demo = c.create_placement(
            'demo', x=(total_width - preview_width) * ratio, y=1,
            width=width, scaler=ueberzug.ScalerOption.COVER.value)
        demo.path = sys.argv[1]
        demo.visibility = ueberzug.Visibility.VISIBLE
        time.sleep(1)
