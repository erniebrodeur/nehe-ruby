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

  # draw a triangle (in smooth coloring mode)
  glBegin(GL_POLYGON)                   # start drawing a polygon
  glColor3f(  1.0, 0.0, 0.0)             # Set The Color To Red
  glVertex3f( 0.0, 1.0, 0.0)             # Top
  glColor3f(  0.0, 1.0, 0.0)             # Set The Color To Green
  glVertex3f( 1.0,-1.0, 0.0)             # Bottom Right
  glColor3f(  0.0, 0.0, 1.0)             # Set The Color To Blue
  glVertex3f(-1.0,-1.0, 0.0)             # Bottom Left  
  glEnd()                                # we're done with the polygon 
                                          # (smooth color interpolation)    
  glTranslatef(3.0,0.0,0.0)               # Move Right 3 Units

  # draw a square (quadrilateral)
  glColor3f(0.5,0.5,1.0)                 # set color to a blue shade.
  glBegin(GL_QUADS)                     # start drawing a polygon (4 
                                          # sided)
  glVertex3f(-1.0, 1.0, 0.0)             # Top Left
  glVertex3f( 1.0, 1.0, 0.0)             # Top Right
  glVertex3f( 1.0,-1.0, 0.0)             # Bottom Right
  glVertex3f(-1.0,-1.0, 0.0)             # Bottom Left  
  glEnd();                               # done with the polygon

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


#Initialize GLUT state - glut will take any command line arguments that pertain
# to it or X Windows - look at its documentation at 
# http://reality.sgi.com/mjk/spec3/spec3.html 
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
