# From Chris Waldon

layout.Flex has an Axis field. The purpose of layout.Flex is to lay out a sequence of child widgets along that axis. To create columns of content, you use the Horizontal axis, and to create rows you use the Vertical.The two kinds of layout.FlexChild have two different strategies for acquiring space along the configured axis.layout.Rigid children are offered all available space and "use up" however much screen space they used in their returned layout.Dimensions.After all layout.Rigid children have been laid out, leftover space is divided among layout.Flexed children according to their configured weights.Note that you do not have to configure any rigid children, in which case you can use layout.Flexed to divide space according to some kind of ratio.I've tried to throw together a simple example of some of these features here.

```
package main

import (
	"image"
	"image/color"
	"log"
	"os"

	"gioui.org/app"
	"gioui.org/io/system"
	"gioui.org/layout"
	"gioui.org/op"
	"gioui.org/op/clip"
	"gioui.org/op/paint"
)

type (
	C = layout.Context
	D = layout.Dimensions
)

// layoutRect paints a colored rectangle whose size is governed by the minimum
// constraints.
func layoutRect(gtx C, col color.NRGBA) D {
	paint.FillShape(gtx.Ops, col, clip.Rect{Max: gtx.Constraints.Min}.Op())
	return D{Size: gtx.Constraints.Min}
}

func main() {
	go func() {
		w := app.NewWindow(app.Title("Flex"))
		if err := loop(w); err != nil {
			log.Fatal.Printf(err)
		}
		os.Exit(0)
	}()
	app.Main()
}

func loop(w *app.Window) error {
	var ops op.Ops
	for event := range w.Events() {
		switch event := event.(type) {
		case system.DestroyEvent:
			return event.Err
		case system.FrameEvent:
			gtx := layout.NewContext(&ops, event)
			layoutFlexes(gtx)
			event.Frame(gtx.Ops)
		}
	}
	return nil
}

// layoutFlexes demonstrates some of the layout.Flex API.
func layoutFlexes(gtx C) D {
	// The outer flex creates columns with their widths determined by the ratio between their
	// Flexed weights.
	return layout.Flex{
		Axis: layout.Horizontal,
	}.Layout(gtx,
		layout.Flexed(.5, func(gtx layout.Context) layout.Dimensions {
			// The Flex will set appropriate minimum constraints in the gtx.Constraints.
			return layoutRect(gtx, color.NRGBA{R: 100, G: 100, A: 255})
		}),
		layout.Flexed(1, func(gtx layout.Context) layout.Dimensions {
			// This inner flex creates rows. The rows are leveraging the Rigid child type to
			// have fixed sizes, and are using the Spacing and Alignment fields to control
			// how the rigid children are positioned since they do not use up all of the space.
			return layout.Flex{
				Axis:      layout.Vertical,
				Spacing:   layout.SpaceAround,
				Alignment: layout.Middle,
			}.Layout(gtx,
				layout.Rigid(func(gtx layout.Context) layout.Dimensions {
					// The Flex expects this child to have a fixed, internally-determined size since
					// we've made it rigid. Clear our minimum X constraint (so that we aren't forced
					// to take up the entire width of the area) and draw a square.
					size := gtx.Dp(100)
					gtx.Constraints.Min.X = 0
					gtx.Constraints = gtx.Constraints.AddMin(image.Pt(size, size))
					return layoutRect(gtx, color.NRGBA{B: 100, G: 100, A: 255})
				}),
				layout.Rigid(func(gtx layout.Context) layout.Dimensions {
					// The Flex expects this child to have a fixed, internally-determined size since
					// we've made it rigid. Clear our minimum X constraint (so that we aren't forced
					// to take up the entire width of the area) and draw a square.
					size := gtx.Dp(300)
					gtx.Constraints.Min.X = 0
					gtx.Constraints = gtx.Constraints.AddMin(image.Pt(size, size))
					return layoutRect(gtx, color.NRGBA{B: 100, G: 100, A: 255})
				}),
			)
		}),
		layout.Flexed(.5, func(gtx layout.Context) layout.Dimensions {
			// The Flex will set appropriate minimum constraints in the gtx.Constraints.
			return layoutRect(gtx, color.NRGBA{R: 100, B: 100, A: 255})
		}),
	)
```
