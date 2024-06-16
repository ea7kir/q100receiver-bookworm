# giocanvas

see: [giocanvas](https://github.com/ajstarks/giocanvas/blob/master/compchart/main.go)

and: [ajstarks](https://github.com/ajstarks/giocanvas)

polygon line 112 [here](https://github.com/ajstarks/giocanvas/blob/master/play/main.go)

import
```
"github.com/ajstarks/giocanvas"
```
in the switch statement
```
case system.FrameEvent:
    // ...
    canvas := giocanvas.NewCanvas(float32(e.Size.X), float32(e.Size.Y), system.FrameEvent{})

    // Title
	canvas.Background(bgcolor)

    colx = 20
	canvas.TextMid(colx, 92, titlesize, "Canvas API", labelcolor)
	canvas.TextWrap(colx+15, 95, titlesize*0.3, 50, subtitle, labelcolor
	// Lines
	canvas.TextMid(colx, 80, labelsize, "Line", labelcolor)
	canvas.Line(10, 70, colx+5, 65, lw, tcolor)
	canvas.Coord(10, 70, subsize, "P0", labelcolor)
	canvas.Coord(colx+5, 65, subsize, "P1", labelcolor
	canvas.Line(colx, 70, 35, 75, lw, fcolor)
	canvas.Coord(colx, 70, subsize, "P0", labelcolor)
	canvas.Coord(35, 75, subsize, "P1", labelcolor)

    // Polygon
    canvas.TextMid(colx, 30, labelsize, "Polygon", labelcolor)
    xp := []float32{45, 60, 70, 70, 60, 45}
    yp := []float32{25, 20, 25, 5, 10, 5}
    for i := 0; i < len(xp); i++ {
    	canvas.Coord(xp[i], yp[i], subsize, fmt.Sprintf("P%d", i), labelcolor)
    }
    canvas.Polygon(xp, yp, fcolor)

    e.Frame(canvas.Context.Ops)
    // ...
```
and somewhere else
```
tcolor := color.NRGBA{128, 0, 0, 150}
fcolor := color.NRGBA{0, 0, 128, 150}
bgcolor := color.NRGBA{255, 255, 255, 255}
labelcolor := color.NRGBA{50, 50, 50, 255}

var colx float32
var lw float32 = 0.2
var labelsize float32 = 2
titlesize := labelsize * 2
subsize := labelsize * 0.7
subtitle := `A canvas API for Gio applications using high-level objects and a percentage-based coordinate system (https://github.com/ajstarks/giocanvas)`


var cw, ch int
flag.IntVar(&cw, "width", 1600, "canvas width")
flag.IntVar(&ch, "height", 1000, "canvas height")
flag.Parse()
width := float32(cw)
height := float32(ch)
```
