class FSVGBorder extends FPoly {
  RShape m_shape;

  float w = 1280;
  float h = 640;  

  FSVGBorder() {
    super();

    RShape fullSvg = RG.loadShape("border.svg");
    m_shape = fullSvg.getChild("object");
    RShape outline = fullSvg.getChild("outline");

    if (m_shape == null || outline == null) {
      println("ERROR: Couldn't find the shapes called 'object' and 'outline' in the SVG file.");
      return;
    }

    m_shape.transform(0, 0, w, h); 
    outline.transform(0, 0, w, h); 

    RPoint[] points = outline.getPoints();

    if (points == null) return;

    for (int i=0; i<points.length; i++) {
      this.vertex(points[i].x, points[i].y);
    }
  }

  void draw(PGraphics applet) {
    preDraw(applet);
    m_shape.draw(applet);
    postDraw(applet);
  }
}