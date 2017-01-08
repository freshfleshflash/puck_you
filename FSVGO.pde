class FSVGO extends FPoly {
  RShape m_shape;

  float w = 107;
  float h = 72;  

  FSVGO() {
    super();

    this.setStatic(true);

    RShape fullSvg = RG.loadShape("fff.svg");
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