# Updated By: Ernie Brodeur (ebrodeur@ujami.net) to use the more current ffi-opengl bindings.
# HomePage:   https://github.com/erniebrodeur/nehe-ruby
# Originaly by:
# (c) 2004 Ben Goodspeed
# Lesson 2-Ruby, based on the tutorials at nehe.gamedev.net
#   based on Jeff Molofee (1999), Cora Hessey (2002)(perl port).

require "ffi-opengl"
include FFI, GL, GLU, GLUT
# Tweakables
@width = 640
@height = 480

# keycode we match against in the keyboard listener
ESCAPE = 27

def initGl
    # clear to black
    glClearColor(0.0,0.0,0.0,0.0)

    glClearDepth(1.0)
    glDepthFunc(GL_LESS)         

    # Enables depth testing with that type
    glEnable(GL_DEPTH_TEST)              
    
    # Enables smooth color shading
    glShadeModel(GL_SMOOTH)      

    # Reset the projection matrix
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity

    # Calculate the aspect ratio of the Window
    gluPerspective(45.0, @width/@height, 0.1, 100.0)

    # Reset the modelview matrix
    glMatrixMode(GL_MODELVIEW)
end

def DrawGLScene
    # Clear the screen and the depth buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)  

    # Reset the view
    glLoadIdentity

    # Move to the left 1.5 units and into the screen 6.0 units
    glTranslatef(-1.5, 0.0, -6.0) 
        
    # -- Draw a triangle --
    glColor3f(1.0,1.0,1.0)
    # Begin drawing a polygon
    glBegin(GL_POLYGON)
      glVertex3f( 0.0, 1.0, 0.0)     # Top vertex
      glVertex3f( 1.0, -1.0, 0.0)    # Bottom right vertex
      glVertex3f(-1.0, -1.0, 0.0)    # Bottom left vertex
    # Done with the polygon
    glEnd

    # Move 3 units to the right
    glTranslatef(3.0, 0.0, 0.0)

    # -- Draw a square (quadrilateral) --
    # Begin drawing a polygon (4 sided)
    glBegin(GL_QUADS)
      glVertex3f(-1.0, 1.0, 0.0)       # Top Left vertex
      glVertex3f( 1.0, 1.0, 0.0)       # Top Right vertex
      glVertex3f( 1.0, -1.0, 0.0)      # Bottom Right vertex
      glVertex3f(-1.0, -1.0, 0.0)      # Bottom Left  
    glEnd                
    glFlush
    # Since this is double buffered, swap the buffers.
    # This will display what just got drawn.
    glutSwapBuffers
end

def ReSizeGLScene(w, h)
    h = 1 if h == 0
    @width, @height = w,h
    glViewport(0, 0, @width, @height)              
    # Re-initialize the window (same lines from InitGL)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity
    gluPerspective(45.0, @width/@height, 0.1, 100.0)
    glMatrixMode(GL_MODELVIEW)
end

def keyPressed(key,x ,y)
    case (key)
        when ESCAPE
        exit 0
        when 'f'[0]
        glutReshapeWindow(640,480)
    end
end

def init(string)
  #Initialize GLUT state - glut will take any command line arguments that pertain
  # to it or X Windows - look at its documentation at 
  # http://reality.sgi.com/mjk/spec3/spec3.html 
  glutInit(MemoryPointer.new(:int, 1).put_int(0, 0), 
           MemoryPointer.new(:pointer, 1).put_pointer(0, nil))
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
  glutCreateWindow(string)
end

def callbacks
  # Register the function to do all our OpenGL drawing.
  glutDisplayFunc(method(:DrawGLScene).to_proc)

  # Even if there are no events, redraw our gl scene.
  glutIdleFunc(method(:DrawGLScene).to_proc)

  # Register the function called when our window is resized.
  glutReshapeFunc(method(:ReSizeGLScene).to_proc)

  # Register the function called when the keyboard is pressed.
  glutKeyboardFunc(method(:keyPressed).to_proc)
end


if __FILE__ == $0
  init($0)
  callbacks
  glutMainLoop()
end

