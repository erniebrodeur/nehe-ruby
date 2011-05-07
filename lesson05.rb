# Updated By: Ernie Brodeur (ebrodeur@ujami.net) to use the more current ffi-opengl bindings.
# HomePage:   https://github.com/erniebrodeur/nehe-ruby
# Originaly by:
# This code was created by Jeff Molofee '99 
# Conversion to Ruby by Manolo Padron Martinez (manolopm@cip.es)

require "ffi-opengl"
include FFI, GL, GLU, GLUT

# A general OpenGL initialization function.  Sets all of the initial parameters

def InitGL(width, height) # We call this right after our OpenGL window 
                          # is created.

  glClearColor(0.0, 0.0, 0.0, 0.0) # This Will Clear The Background 
                                    # Color To Black
  glClearDepth(1.0)                # Enables Clearing Of The Depth Buffer
  glDepthFunc(GL_LESS)            # The Type Of Depth Test To Do
  glEnable(GL_DEPTH_TEST)         # Enables Depth Testing
  glShadeModel(GL_SMOOTH)         # Enables Smooth Color Shading
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()                 # Reset The Projection Matrix
  gluPerspective(45.0,Float(width)/Float(height),0.1,100.0) # Calculate The Aspect Ratio 
                                               # Of The Window
  glMatrixMode(GL_MODELVIEW)
end

# The function called when our window is resized (which shouldn't happen, 
# because we're fullscreen) 
ReSizeGLScene = Proc.new {|width, height|
  if (height==0) # Prevent A Divide By Zero If The Window Is Too Small
    height=1
  end
  glViewport(0,0,width,height) # Reset The Current Viewport And
                                # Perspective Transformation
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  gluPerspective(45.0,Float(width)/Float(height),0.1,100.0)
  glMatrixMode(GL_MODELVIEW)
}

# The main drawing function. 
DrawGLScene = Proc.new {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) # Clear The Screen And
                                          # The Depth Buffer
  glLoadIdentity()                       # Reset The View
  glTranslatef(-1.5, 0.0, -6.0)           # Move Left 1.5 Units And Into The 
                                          # Screen 6.0
  glRotatef($rtri,0.0,1.0,0.0)            # Rotate the triangle on the Y Axis

  # draw a triangle (in smooth coloring mode)
  glBegin(GL_POLYGON)                   # start drawing a polygon

  # front face of pyramid
  glColor3f(  1.0, 0.0, 0.0)             # Set The Color To Red
  glVertex3f( 0.0, 1.0, 0.0)             # Top
  glColor3f(  0.0, 1.0, 0.0)             # Set The Color To Green
  glVertex3f( 1.0,-1.0, 0.0)             # Bottom Right
  glColor3f(  0.0, 0.0, 1.0)             # Set The Color To Blue
  glVertex3f(-1.0,-1.0, 0.0)             # Bottom Left  

  # right face of pyramid
  glColor3f(  1.0, 0.0, 0.0)             # Red
  glVertex3f( 0.0, 1.0, 0.0)             # Top of triangle (Right)
  glColor3f(  0.0, 0.0, 1.0)             # Blue
  glVertex3f( 1.0,-1.0, 1.0)             # Left of triangle (Right)
  glColor3f(  1.0, 0.0, 0.0)             # Green
  glVertex3f( 1.0,-1.0,-1.0)             # Right of triangle (Right)

  # back face of pyramid
  glColor3f(  1.0, 0.0, 0.0)             # Red
  glVertex3f( 0.0, 1.0, 0.0)             # Top of triangle (Back)
  glColor3f(  0.0, 1.0, 0.0)             # Green
  glVertex3f( 1.0,-1.0,-1.0)             # Left of triangle (Back)
  glColor3f(  0.0, 0.0, 1.0)             # Blue
  glVertex3f(-1.0,-1.0,-1.0)             # Right of triangle (Back

  # left face of pyramid
  glColor3f(  1.0, 0.0, 0.0)             # Red
  glVertex3f( 0.0, 1.0, 0.0)             # Top of triangle (Left)
  glColor3f(  0.0, 0.0, 1.0)             # Blue
  glVertex3f(-1.0,-1.0,-1.0)             # Left of triangle (Left)
  glColor3f(  1.0, 0.0, 0.0)             # Green
  glVertex3f(-1.0,-1.0, 1.0)             # Right of triangle (Left)

  glEnd()                                # Done drawing the pyramid

  glLoadIdentity()                       # make sure we're no longer rotated.
  glTranslatef(1.5,0.0,-7.0)              # Move Right 3 Units, and back into 
                                          # the screen 7.0
  glRotatef($rquad,1.0,1.0,1.0)           # Rotate the quad on the X Axis
  # draw a cube (6 quadrilateral)
  glBegin(GL_QUADS)                     # start drawing the cube

  # top of cube
  glColor3f(0.0,1.0,0.0)               # Set The Color To Blue
  glVertex3f( 1.0, 1.0,-1.0)             # Top Right Of The Quad (Top)
  glVertex3f(-1.0, 1.0,-1.0)             # Top Left Of The Quad (Top)
  glVertex3f(-1.0, 1.0, 1.0)             # Bottom Left Of The Quad (Top)
  glVertex3f( 1.0, 1.0, 1.0)             # Bottom Right Of The Quad (Top)

  # bottom of cube
  glColor3f(1.0,0.5,0.0)             	# Set The Color To Orange
  glVertex3f( 1.0,-1.0, 1.0)             # Top Right Of The Quad (Bottom)
  glVertex3f(-1.0,-1.0, 1.0)             # Top Left Of The Quad (Bottom)
  glVertex3f(-1.0,-1.0,-1.0)             # Bottom Left Of The Quad (Bottom)
  glVertex3f( 1.0,-1.0,-1.0)             # Bottom Right Of The Quad (Bottom)

  # front of cube
  glColor3f(1.0,0.0,0.0)             	# Set The Color To Red
  glVertex3f( 1.0, 1.0, 1.0)             # Top Right Of The Quad (Front)
  glVertex3f(-1.0, 1.0, 1.0)             # Top Left Of The Quad (Front)
  glVertex3f(-1.0,-1.0, 1.0)             # Bottom Left Of The Quad (Front)
  glVertex3f( 1.0,-1.0, 1.0)             # Bottom Right Of The Quad (Front)

  # back of cube.
  glColor3f(1.0,1.0,0.0)             	# Set The Color To Yellow
  glVertex3f( 1.0,-1.0,-1.0)             # Top Right Of The Quad (Back)
  glVertex3f(-1.0,-1.0,-1.0)             # Top Left Of The Quad (Back)
  glVertex3f(-1.0, 1.0,-1.0)             # Bottom Left Of The Quad (Back)
  glVertex3f( 1.0, 1.0,-1.0)             # Bottom Right Of The Quad (Back)

  # left of cube
  glColor3f(0.0,0.0,1.0)             	# Blue
  glVertex3f(-1.0, 1.0, 1.0)             # Top Right Of The Quad (Left)
  glVertex3f(-1.0, 1.0,-1.0)             # Top Left Of The Quad (Left)
  glVertex3f(-1.0,-1.0,-1.0)             # Bottom Left Of The Quad (Left)
  glVertex3f(-1.0,-1.0, 1.0)             # Bottom Right Of The Quad (Left)

  # Right of cube
  glColor3f(1.0,0.0,1.0)             	# Set The Color To Violet
  glVertex3f( 1.0, 1.0,-1.0);	          # Top Right Of The Quad (Right)
  glVertex3f( 1.0, 1.0, 1.0)             # Top Left Of The Quad (Right)
  glVertex3f( 1.0,-1.0, 1.0)             # Bottom Left Of The Quad (Right)
  glVertex3f( 1.0,-1.0,-1.0)             # Bottom Right Of The Quad (Right)
  glEnd();                               # done with the polygon

  $rtri=$rtri+15.0                        # Increase the rotation variable for
                                          # the Triangle
  $rquad=$rquad-15.0                      # Decrease the rotation variable for 
                                          # the Quad
  # we need to swap the buffer to display our drawing.
  glutSwapBuffers();
}



# The function called whenever a key is pressed.
keyPressed = Proc.new {|key, x, y| 

  # If escape is pressed, kill everything. 
  if (key == 27) 
    # shut down our window 
    glutDestroyWindow($window)
    # exit the program...normal termination.
    exit(0)                   
  end
}

# Rotation angle for the triangle.
$rtri=0.0

#Rotation angle for the quadrilateral.
$rquad=0.0

#Initialize GLUT state - glut will take any command line arguments that pertain
glutInit(MemoryPointer.new(:int, 1).put_int(0, 0), 
         MemoryPointer.new(:pointer, 1).put_pointer(0, nil))


#Select type of Display mode:   
# Double buffer 
# RGBA color
# Alpha components supported 
# Depth buffer 
glutInitDisplayMode(GLUT_RGBA|GLUT_DOUBLE|GLUT_ALPHA|GLUT_DEPTH)

# get a 640x480 window
glutInitWindowSize(640,480)

# the window starts at the upper left corner of the screen
glutInitWindowPosition(0,0)

# Open a window
$window=glutCreateWindow("Jeff Molofee's GL Code Tutorial ... NeHe '99")

# Register the function to do all our OpenGL drawing.
glutDisplayFunc(DrawGLScene)

# Even if there are no events, redraw our gl scene.
glutIdleFunc(DrawGLScene)

# Register the function called when our window is resized.
glutReshapeFunc(ReSizeGLScene)

# Register the function called when the keyboard is pressed.
glutKeyboardFunc(keyPressed)

# Initialize our window.
InitGL(640, 480)

# Start Event Processing Engine
glutMainLoop()
