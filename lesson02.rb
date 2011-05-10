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

def display
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

def reshape(w, h)
    h = 1 if h == 0
    @width, @height = w,h
    glViewport(0, 0, @width, @height)              
    # Re-initialize the window (same lines from InitGL)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity
    gluPerspective(45.0, @width/@height, 0.1, 100.0)
    glMatrixMode(GL_MODELVIEW)
end

def keyboard 
    case (key)
        when ESCAPE
        exit 0
        when 'f'[0]
        glutReshapeWindow(640,480)
    end
end

def glinit(string)
  # Initialize glut & open a window
  glutInit(MemoryPointer.new(:int, 1).put_int(0, 0), 
           MemoryPointer.new(:pointer, 1).put_pointer(0, nil))
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
  glutInitWindowSize(@width, @height)
  glutCreateWindow(string)
end

def glcallbacks
  glutReshapeFunc(method(:reshape).to_proc)
  glutDisplayFunc(method(:display).to_proc)
  glutKeyboardFunc(method(:keyboard).to_proc)
end

if __FILE__ == $0
  glinit($0)
  glcallbacks
  glutMainLoop()
end

