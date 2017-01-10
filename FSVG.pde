class FSVG extends FPoly {
  RShape m_shape;

  float w = 144.28;
  float h = 46.28;  
  float axisTranslation = 24;
  float defaultAng = -10;

  FSVG(int player, int dir) {
    super();

    this.setGroupIndex(10000);
    this.setNoFill();
    //this.setFill(229, 71, 70);

    RShape fullSvg = RG.loadShape("racket.svg");
    m_shape = fullSvg.getChild("object");
    RShape outline = fullSvg.getChild("outline");

    if (m_shape == null || outline == null) {
      println("ERROR: Couldn't find the shapes called 'object' and 'outline' in the SVG file.");
      return;
    }

    m_shape.transform(-axisTranslation, -h/2, w, h); 
    outline.transform(-axisTranslation, -h/2, w, h); 

    m_shape.rotate(radians(defaultAng * dir * player)); 
    outline.rotate(radians(defaultAng * dir * player)); 

    m_shape.scale(player, 1);
    outline.scale(player, 1);

    RPoint[] points = outline.getPoints();

    if (points == null) return;

    for (int i = 0; i < points.length; i++) {
      this.vertex(points[i].x, points[i].y);
    }
  }

  void draw(PGraphics applet) {
    preDraw(applet);
    m_shape.draw(applet);
    postDraw(applet);
  }
}