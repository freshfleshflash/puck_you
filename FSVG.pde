class FSVG extends FPoly {
  RShape m_shape;

  float w = 200;
  float h = 67;  
  float axisTranslation = 12;
  float defaultAng = 120;

  FSVG(String filename, int player, int dir) {
    super();

    RShape fullSvg = RG.loadShape(filename);
    m_shape = fullSvg.getChild("object");
    RShape outline = fullSvg.getChild("outline");

    if (m_shape == null || outline == null) {
      println("ERROR: Couldn't find the shapes called 'object' and 'outline' in the SVG file.");
      return;
    }

    m_shape.transform(-axisTranslation, -h/2, w, h); 
    outline.transform(-axisTranslation, -h/2, w, h); 

    m_shape.rotate(radians(defaultAng * dir)); 
    outline.rotate(radians(defaultAng * dir)); 

    m_shape.scale(player, 1);
    outline.scale(player, 1);

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