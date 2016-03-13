// Number of hypercube dimensions.
int dimension = 7;

//--------------------------------------------------------------------------------------------------
// The space where we will draw in.
Space space;
// Array that will contain each axis.
Axis[] axes;

int axis_thickness=7;
boolean axisVisible=true;

// Define a hypercube.
Hypercube hypercube;

//--------------------------------------------------------------------------------------------------
// We will only refresh the screen when necessary.
boolean refresh;
// Store mouse input information.
Mouse mouse;

PVector origin;

void setup()
{
  size(window.innerWidth * 0.8, window.innerHeight * 0.8);
  //size(500, 250);
  //frameRate(40);
  //fullScreen();

  refresh = true;
  mouse = new Mouse();

  hypercube = new Hypercube(dimension);

  // The pixel space location where the n-dimensional space origin will be drawn.
  origin = new PVector(width/2, height/2);  
  // Create a new n-dimensional space.
  space = new Space(dimension, origin);
  // Now we can access the axes created for the n-dimensional space.
  axes = space.getAxes();

  // Set the colour and thickness of our axes.
  axes[0].style(new PVector(157, 28, 18), axis_thickness);
  axes[1].style(new PVector(101, 173, 36), axis_thickness);

  axes[2].style(new PVector(47, 132, 129), axis_thickness);
  axes[3].style(new PVector(255, 255, 84), axis_thickness);
  axes[4].style(new PVector(255, 0, 255), axis_thickness);
  axes[5].style(new PVector(0, 255, 255), axis_thickness);
  axes[6].style(new PVector(50,50,50), axis_thickness);
}

void draw()
{
  if(refresh)
  {
    d();
  }
  //hypercube.drawVolume(100, axes, space.origin);
  //space.draw();
  //space.drawAxes();
  
}
void d()
{
  space = new Space(axes);
  background(255,255,255,0);
  refresh = false;
  space.add(hypercube);
  space.draw();
 
  if(axisVisible)
  {
    space.drawAxes();
  }
}

//--------------------------------------------------------------------------------------------------
void mouseMoved()
{
  // Update the screen if the mouse is moved.
  refresh = true;
}
//--------------------------------------------------------------------------------------------------
void mousePressed()
{
  if(axisVisible)
  {
    PVector mousePosition = new PVector(mouseX, mouseY);
    // Check if an axis dragbutton has been selected on mousedown event.
    for (int i=axes.length - 1; i >=0; --i)
    {
      DragButton button = axes[i].getDragButton();
      if (button.check(mousePosition))
      {
        mouse.dragButton = button;
        mouse.drag = true;
      }
    }
  }
  
  
  if(mouseButton == RIGHT)
  {
    axisVisible = !axisVisible;
    refresh = true;
  }
}
//--------------------------------------------------------------------------------------------------
void mouseDragged()
{
  if (mouse.drag)
  {
  
    float x = constrain(mouseX, width * .1, width * .9);
    float y = constrain(mouseY, height * .1, height * .9);
    PVector move = new PVector(x, y);
    PVector difference = move.get();
    difference.sub(origin);
    if (difference.mag() > axis_thickness * 2.5)
    {
      mouse.dragButton.move(move);
    }
    else
    {
      mouse.dragButton.move(origin);
    }
    refresh = true;
  }
  // Comment out the next line for Java mode, uncomment for Javascript.
  d();
}
//--------------------------------------------------------------------------------------------------
void mouseReleased()
{ 
  mouse.drag = false;
}



//--------------------------------------------------------------------------------------------------
//  Function which converts hyperspace coordinates to screen pixels.
//--------------------------------------------------------------------------------------------------
public static float[][] hyperspaceToPixels(float[][] positions, Axis[] axes, PVector origin)
{
  int x, y;
  float[][] pixelArray = new float[positions.length][2];
  for(int p=0; p < positions.length; ++p)
  {
    x = 0;
    y = 0;
    for(int i=0; i < axes.length; ++i)
    {
      x += positions[p][i] * axes[i].relativeEndPoint.x;
      y += positions[p][i] * axes[i].relativeEndPoint.y;
    }
    pixelArray[p][0] = x + origin.x;
    pixelArray[p][1] = y + origin.y;
  }
  return pixelArray;
}
//--------------------------------------------------------------------------------------------------
//  An axis that can be used with other axes to create an n-dimensional space.
//--------------------------------------------------------------------------------------------------
class Axis
{

//--------------------------------------------------------------------------------------------------
//  The pixel space position of the Axis origin. 
//--------------------------------------------------------------------------------------------------
  PVector origin;
//--------------------------------------------------------------------------------------------------
//  The pixel space distance from the Axis origin to the Axis end point. 
//--------------------------------------------------------------------------------------------------
  PVector relativeEndPoint;
//--------------------------------------------------------------------------------------------------
//  The pixel space position of the Axis end point. 
//--------------------------------------------------------------------------------------------------
  PVector absoluteEndPoint;
//--------------------------------------------------------------------------------------------------
//  Colour to render the Axis when drawn.
//--------------------------------------------------------------------------------------------------
  PVector colour;
//--------------------------------------------------------------------------------------------------
//  Thickness to render the Axis when drawn.
//--------------------------------------------------------------------------------------------------
  float weight;
//--------------------------------------------------------------------------------------------------
//  The DragButton attatched to the end of this axis. 
//--------------------------------------------------------------------------------------------------
  DragButton dragButton;

//--------------------------------------------------------------------------------------------------
//  Axis constructor, requiring the pixel space positions of Axis origin and end point. 
//--------------------------------------------------------------------------------------------------
  Axis(float originX, float originY, float endPointX, float endPointY) //<>//
  {
    origin = new PVector(originX, originY);
    moveEndPoint(new PVector(endPointX, endPointY)); //<>//
    colour = new PVector(0, 0, 0);
    weight = 1;
    dragButton = new DragButton(absoluteEndPoint, 10, colour);
    style(new PVector(50,50,50), (width+height)/2/80);
  }
  
//--------------------------------------------------------------------------------------------------
//  Changes how the Axis will be rendered.
//--------------------------------------------------------------------------------------------------  
  void style(PVector _colour, float _weight)
  {
    colour = _colour;
    weight = _weight;
    dragButton.size = _weight*5;
    dragButton.colour = _colour;
  }

//--------------------------------------------------------------------------------------------------
//  Changes the pixel space position of the Axis endpoint.
//--------------------------------------------------------------------------------------------------
  void moveEndPoint(PVector _position)
  {
    absoluteEndPoint = new PVector(_position.x, _position.y);
    _position.sub(origin);
    relativeEndPoint = _position;
  }

//--------------------------------------------------------------------------------------------------
//  Renders the axis to screen.
//--------------------------------------------------------------------------------------------------
  void draw()
  {
    moveEndPoint(new PVector(dragButton.position.x, dragButton.position.y));
    stroke(colour.x, colour.y, colour.z);
    strokeWeight(weight);
    line(origin.x, origin.y, origin.x + relativeEndPoint.x, origin.y + relativeEndPoint.y);
    dragButton.draw();
  }

//--------------------------------------------------------------------------------------------------
//  Returns the dragButton attached to this axis.
//--------------------------------------------------------------------------------------------------
  DragButton getDragButton()
  {
    return dragButton;
  }
}
//--------------------------------------------------------------------------------------------------
//  A dragable button that can be used to control objects in pixel space.
//--------------------------------------------------------------------------------------------------
class DragButton
{

//--------------------------------------------------------------------------------------------------
//  The position of the DragButton in pixel space.
//--------------------------------------------------------------------------------------------------
  PVector position;
//--------------------------------------------------------------------------------------------------
//  The size of the DragButton.
//--------------------------------------------------------------------------------------------------
  float size;
//--------------------------------------------------------------------------------------------------
//  The colour of the DragButton.
//--------------------------------------------------------------------------------------------------
  PVector colour;

//--------------------------------------------------------------------------------------------------
//  DragButton constructor.
//--------------------------------------------------------------------------------------------------
  DragButton(PVector _position, float _size, PVector _colour)
  {
    move(_position);
    size = _size;
    colour = _colour;
  }

//--------------------------------------------------------------------------------------------------
//  Moves the DragButton in pixel space.
//--------------------------------------------------------------------------------------------------
  void move(PVector _position)
  {
    position = _position;
  }

//--------------------------------------------------------------------------------------------------
//  Renders the DragButton.
//--------------------------------------------------------------------------------------------------
  void draw()
  {
    fill(230,230,230);
    stroke(colour.x, colour.y, colour.z);
    ellipse(position.x, position.y, size, size);
  }

//--------------------------------------------------------------------------------------------------
//  Checks if a pixel space position is within the boundry of a DragButton.
//--------------------------------------------------------------------------------------------------
  boolean check(PVector _position)
  {
    float boundry =  pow(_position.x - position.x, 2) + pow(_position.y - position.y, 2) - pow(size, 2);
    if(boundry < 0)
    {
      return true;
    }
    else 
    {
      return false;
    }
  }

}
//--------------------------------------------------------------------------------------------------
//  Base class for all n-dimensional shapes.
//--------------------------------------------------------------------------------------------------
class DrawObject
{

//--------------------------------------------------------------------------------------------------
//  The n-dimensional position of the shape's centre.
//--------------------------------------------------------------------------------------------------
  int dimension;
//--------------------------------------------------------------------------------------------------
//  The n-dimensional position of the shape's centre.
//--------------------------------------------------------------------------------------------------
  float[] centre;
//--------------------------------------------------------------------------------------------------
//  The size of this shape.
//--------------------------------------------------------------------------------------------------
  float size;

//--------------------------------------------------------------------------------------------------
//  All DrawObjects should be drawable on a set of n-dimensional axes.
//--------------------------------------------------------------------------------------------------
  void draw(Axis[] axes, PVector origin)
  {
  }

//--------------------------------------------------------------------------------------------------
//  All DrawObjects should be movable along a set of n-dimensional axes.
//--------------------------------------------------------------------------------------------------
  void move(Axis[] axes, PVector _position)
  {   
  }
  
}
//--------------------------------------------------------------------------------------------------
//  An n-dimensional cube.
//  Also called an n-cube, but HYPERCUBE sounds much cooler.
//--------------------------------------------------------------------------------------------------
class Hypercube extends DrawObject
{
  
//--------------------------------------------------------------------------------------------------
//  Stores the hyperspace coordinates of the vertices of the hypercube.
//--------------------------------------------------------------------------------------------------
  float[][] vertexArray;
//--------------------------------------------------------------------------------------------------
//  Stores the indices of vertices in the vertexArray that connect to make an edge.
//--------------------------------------------------------------------------------------------------
  int[][] edgeArray;
  
//--------------------------------------------------------------------------------------------------
//  Hypercube constructor, creates a hypercube of n-dimensions.
//--------------------------------------------------------------------------------------------------
  Hypercube(int _dimension)
  {
    centre = new float[_dimension];
    // Centre the hypercube at zero by default.
    for(int i=0; i < dimension; ++i)
    {
       centre[i] = 0;
    }
    // Set the size of the hypercube to 1 by default.
    size = 1;
    dimension = _dimension;

    generate();
  }

//--------------------------------------------------------------------------------------------------
//  Hypercube constructor which defines the centre point in n-dimensional space.
//--------------------------------------------------------------------------------------------------
  Hypercube(float[] _centre, float _size)
  {
    centre = _centre;
    size = _size;
    dimension = centre.length;

    generate();
  }

//--------------------------------------------------------------------------------------------------
//  Calculates the vertices and edges of the hypercube in n-dimensional space.
//--------------------------------------------------------------------------------------------------
  void generate()
  {   
    // An n-dimensional hypercube will have 2^n vertices.
    vertexArray = new float[int(pow(2, dimension))][dimension];
    // An n-dimensional hypercube will have (2^(n-1))*n edges.
    edgeArray = new int[int(pow(2, dimension-1) * dimension)][2];
    
    // The hypercube is generated relative to the first vertex,
    // so an offset is needed to position the hypercube correctly.
    float[] offset = new float[dimension];
    // The boundry the minimum distance from the centre to the outside of the hypercube.
    // This happens to be half the width.
    float boundry = size/2;
    // Calculate the offset. 
    for(int d=0; d < dimension; ++d)
    {
      offset[d] = centre[d] - boundry;
    }
    
    // Offset the first vertex.
    for(int d=0; d < dimension; ++d)
    {
      vertexArray[0][d] = offset[d];
      vertexArray[1][d] = offset[d];
    }
    // Move the first vertex into position.
    vertexArray[1][0] += size;    
    // Connect the first two vertices to form an edge.
    edgeArray[0][0] = 0;
    edgeArray[0][1] = 1;

    // Keep track of how many vertices andd edges there are.
    int verts = 2;
    int edges = 1;
    
    // Calculate the vertex positions and edge connections for each dimension.
    for(int d=1; d < dimension; ++d)
    {
      //Calculate the current number of vertices and edges.
      verts = int(pow(2, d));
      edges = int(pow(2, d-1) * d);
      
      // Duplicate all existing vertices 
      // Offset these new vertices along the next dimension.  
      for(int v=0; v < verts; ++v)
      {
        for(int dim=0; dim < dimension; ++dim)
        {
          vertexArray[verts+v][dim] = vertexArray[v][dim];
        }
        vertexArray[verts+v][d] += size;
      }
      
      // Duplicate all existing edges.
      // Offset the new edges so that they connect the new vertices together.
      for(int e=0; e < edges; ++e)
      {
        edgeArray[edges+e][0] = edgeArray[e][0] + verts;
        edgeArray[edges+e][1] = edgeArray[e][1] + verts;
      }
      
      // Connect all the duplicated vertices in pairs to form new edges. 
      for(int v=0; v < verts; ++v)
      {
        edgeArray[edges*2+v][0] = v;
        edgeArray[edges*2+v][1] = v+verts;
      }
      
      //verts = int(pow(2, d+1));
      //edges = int(pow(2, (d+1)-1) * (d+1));
    }
  }
  
  void draw(Axis[] axes, PVector origin)
  {
    // Convert the vertices for hyperspace into pixel space.
    float[][] pixelSpace = new float[vertexArray.length][2];
    pixelSpace = hyperspaceToPixels(vertexArray, axes, origin);
    
    // Draw the hypercube wireframe in pixel space.
    int edges = edgeArray.length;
    for(int e=0; e < edges; ++e)
    {
      int v1 = edgeArray[e][0];
      int v2 = edgeArray[e][1];
      stroke(0,0,0);
      strokeWeight(1);
      line(pixelSpace[v1][0], pixelSpace[v1][1], pixelSpace[v2][0], pixelSpace[v2][1]);
    }    
  }

  void drawVolume(int samples, Axis[] axes, PVector origin)
  {
    strokeWeight(8);
    float boundry = size/2.0;
    PVector[] col = new PVector[axes.length];
    for(int i=0; i < axes.length; ++i)
    {
      col[i] = axes[i].colour;
    }
    float[] points = new float[axes.length];
    int i=0;
    float x;
    float y;
    float rand;
    int n;
    while(i < samples)
    {
      x = 0;
      y = 0;
      rand = 0;
      n = 0;
      for(Axis axis : axes)
      {
        rand = random(-boundry, boundry);
        x += (centre[n] + rand) * axis.relativeEndPoint.x;
        y += (centre[n] + rand) * axis.relativeEndPoint.y;
        
        points[n] = rand;
        
        ++n;
      }
      int index = 0;
      float max = -1;
      for(int c=0; c < points.length; ++c)
      {
        if(points[c] > max)
        {
          index = c;
          max = points[c];
        }
      }
      PVector colour = axes[index].colour;
      stroke(colour.x,colour.y,colour.z, 50);
      point(x + space.origin.x, y + space.origin.y);
      ++i;
    }
  }

}
class Mouse
{
  // Determines if the mouse is currently being dragged
  boolean drag;
  // Stores the currently selected button
  DragButton dragButton;
}
//--------------------------------------------------------------------------------------------------
//  An n-dimensional space that can be displayed as a 2D visualisation.
//--------------------------------------------------------------------------------------------------
class Space
{
//--------------------------------------------------------------------------------------------------
//  The axes that define the n-dimensional space.
//--------------------------------------------------------------------------------------------------
  Axis[] axes;
//--------------------------------------------------------------------------------------------------
//  The number of dimensions that define the space.
//--------------------------------------------------------------------------------------------------
  int dimension;
//--------------------------------------------------------------------------------------------------
//  The pixel space location of the n-dimensional space origin. 
//--------------------------------------------------------------------------------------------------
  PVector origin;
//--------------------------------------------------------------------------------------------------
//  The objects to be rendered in this space. 
//--------------------------------------------------------------------------------------------------
  ArrayList<DrawObject> drawObjects; 

//--------------------------------------------------------------------------------------------------
//  Space Constructor where all axes begin at the space origin.
//--------------------------------------------------------------------------------------------------
  Space(int _dimension, PVector _origin)
  {
    dimension = _dimension;
    origin = _origin;
    axes = new Axis[_dimension];
    for(int i=0; i < dimension; ++i)
    {
      axes[i] = new Axis(origin.x, origin.y, origin.x, origin.y);
    }
    drawObjects = new ArrayList<DrawObject>();
  }

//--------------------------------------------------------------------------------------------------
//  Space Constructor where the axes must be defined before a space is created.
//--------------------------------------------------------------------------------------------------
  Space(Axis[] _axes)
  {
    dimension = _axes.length;
    axes = _axes;
    origin = axes[0].origin; 
    drawObjects = new ArrayList<DrawObject>();
  }

//--------------------------------------------------------------------------------------------------
//  Returns the axes that define the space.
//--------------------------------------------------------------------------------------------------
  Axis[] getAxes()
  {
    return axes;
  }
  
//--------------------------------------------------------------------------------------------------
//  Converts hyperspace coordinates to screen pixels.
//--------------------------------------------------------------------------------------------------
  PVector hyperspaceToPixel(float[] position)
  {
      int x = 0;
      int y = 0;
      for(int i=0; i < axes.length; ++i)
      {
        x += position[i] * axes[i].relativeEndPoint.x;
        y += position[i] * axes[i].relativeEndPoint.y;
      }
      return new PVector(x + space.origin.x, y+ space.origin.y);
  }

//--------------------------------------------------------------------------------------------------
//  Add a DrawObject to be rendered in this space.
//--------------------------------------------------------------------------------------------------
  void add(DrawObject drawObject)
  {
    drawObjects.add(drawObject);
  }

//--------------------------------------------------------------------------------------------------
//  Render each axis. The lowest dimension will be drawn on top.
//--------------------------------------------------------------------------------------------------
  void drawAxes()
  {
    for(int axis=0; axis < axes.length; ++axis)
    {
      axes[axes.length - 1 - axis].draw();
    }
  }

//--------------------------------------------------------------------------------------------------
//  Render all DrawObjects that have been added to this space.
//--------------------------------------------------------------------------------------------------
  void draw()
  {
    for(DrawObject drawObject : drawObjects)
    {
      drawObject.draw(axes, origin); 
    }
  }
}

