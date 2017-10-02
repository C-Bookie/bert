package com.company;


import org.lwjgl.*;
import org.lwjgl.glfw.*;
import org.lwjgl.opengl.*;
import org.lwjgl.system.*;

import java.awt.*;
import java.io.IOException;
import java.nio.*;

import static java.lang.Thread.sleep;
import static org.lwjgl.glfw.Callbacks.*;
import static org.lwjgl.glfw.GLFW.*;
import static org.lwjgl.opengl.GL11.*;
import static org.lwjgl.system.MemoryStack.*;
import static org.lwjgl.system.MemoryUtil.*;

import com.ericsson.otp.erlang.*;

public class Main {
	
	private static final String NAME = "graph";
	private static final String SERVER = "moo1@computer-48";
	private static String CLIENT = "bert";
//	private static final String COOKIE = "moo";
	private static final String MAIL_BOX = "graphMail";
	
	private final boolean LINK = false;
	
	private long window;
	private OtpNode self;
//	private OtpSelf self;
	private OtpMbox mbox;
//	private OtpPeer client;
	private OtpErlangPid client;
	
	private static final int GRAPH_SIZE = 256;
	private int[] graph;
	private int[] graph2;
	private int step = 0;
	
	public Main() {
		graph = new int[GRAPH_SIZE];
		graph2 = new int[GRAPH_SIZE];
		try {

//			self = new OtpSelf(NAME);    //if no connection to the name server, run 'erl -sname <anything>' in a terminal
//			System.out.println("Registered: " + NAME);
			
//			while (!self.publishPort())
			
			self = new OtpNode(NAME);
			System.out.println("Registered: " + NAME);
			
//          node.setCookie(COOKIE);    //for security, not needed
//			System.out.println("Cookie: " + COOKIE);
			
			mbox = self.createMbox(MAIL_BOX);
			System.out.println("Mail_box: " + MAIL_BOX);

//			client = new OtpPeer(CLIENT);
//			System.out.println("Connected: " + CLIENT);
			
			if (self.ping(CLIENT, 1000))
				System.out.println(client.node());
			else
				System.out.println("nay");
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Constructed:" + NAME);
	}
	
	public int coms(String req) {
		try {
			if (self.ping(SERVER, 1000)) {
//				if (self.ping(CLIENT, 1000)) {
					
					if (LINK)
						mbox.link(self.createPid());
					
					OtpErlangObject[] msg = new OtpErlangObject[2];
					msg[0] = new OtpErlangAtom(req);
					msg[1] = mbox.self();
					OtpErlangTuple tuple = new OtpErlangTuple(msg);
					
					mbox.send(CLIENT, SERVER, tuple);
//					System.out.println("yay");
				
				OtpErlangTuple o = (OtpErlangTuple) mbox.receive();
				OtpErlangList o2 = (OtpErlangList)o.elementAt(1);
//					System.out.println(Integer.toString(step) + ": " + o2.toString());
					return getSum(o2);
//				}
//				else
//					System.out.println(Integer.toString(step) + ": no connection to bert");
			}
			else
				System.out.println(Integer.toString(step) + ": no connection to server");
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		return 0;
	}
	
	public int getSum(OtpErlangList L) {
		int r = 0;
		try {
			for (int i = L.arity()-1; i>=0;i--) {
//				System.out.println(((OtpErlangLong)L.elementAt(i)).intValue());
				r += ((OtpErlangLong)L.elementAt(i)).intValue();
			}
		} catch (OtpErlangRangeException e) {
			e.printStackTrace();
		}
		return r;
	}

	private void init() {
		GLFWErrorCallback.createPrint(System.err).set();

		if ( !glfwInit() )
			throw new IllegalStateException("Unable to initialize GLFW");
		
		glfwDefaultWindowHints();
		glfwWindowHint(GLFW_VISIBLE, GLFW_FALSE);
		glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE);
		
		window = glfwCreateWindow(300, 300, "Hello World!", NULL, NULL);
		if ( window == NULL )
			throw new RuntimeException("Failed to create the GLFW window");
		
		glfwSetKeyCallback(window, (window, key, scancode, action, mods) -> {
			if ( key == GLFW_KEY_ESCAPE && action == GLFW_RELEASE )
				glfwSetWindowShouldClose(window, true); // We will detect this in the rendering loop
		});
		
		// Get the thread stack and push a new frame
		try ( MemoryStack stack = stackPush() ) {
			IntBuffer pWidth = stack.mallocInt(1); // int*
			IntBuffer pHeight = stack.mallocInt(1); // int*
			
			// Get the window size passed to glfwCreateWindow
			glfwGetWindowSize(window, pWidth, pHeight);
			
			// Get the resolution of the primary monitor
			GLFWVidMode vidmode = glfwGetVideoMode(glfwGetPrimaryMonitor());
			
			// Center the window
			glfwSetWindowPos(
					window,
					(vidmode.width() - pWidth.get(0)) / 2,
					(vidmode.height() - pHeight.get(0)) / 2
			);
		} // the stack frame is popped automatically
		
		// Make the OpenGL context current
		glfwMakeContextCurrent(window);
		// Enable v-sync
		glfwSwapInterval(1);
		
		// Make the window visible
		glfwShowWindow(window);
		
	}
	
	private void loop() {
		// This line is critical for LWJGL's interoperation with GLFW's
		// OpenGL context, or any context that is managed externally.
		// LWJGL detects the context that is current in the current thread,
		// creates the GLCapabilities instance and makes the OpenGL
		// bindings available for use.
		GL.createCapabilities();
		
		// Set the clear color
		glClearColor(1.0f, 0.0f, 0.0f, 0.0f);
		
		// Run the rendering loop until the user has attempted to close
		// the window or has pressed the ESCAPE key.
		while ( !glfwWindowShouldClose(window) ) {
			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // clear the framebuffer
			
			test();
			
/*			try {
				sleep(400);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
*/
			glfwSwapBuffers(window); // swap the color buffers
			
			// Poll for window events. The key callback above will only be
			// invoked during this call.
			glfwPollEvents();
		}
	}
	
	private void test() {
		
		graph[step] = coms("getI");
		graph2[step] = coms("getC");
		
		final float xMin = -0.9f;
		final float xMax = 0.9f;
		final float yMin = -0.9f;
		final float yMax = 0.9f;
		
		GL11.glColor3f(0.0f, 1.0f, 0.2f);
		
		for(int i=0; i<GRAPH_SIZE-1; i++)
			drawLine(
					map(xMin, xMax, (float)i/GRAPH_SIZE),
					map(yMin, yMax, graph[(step+i+1)%GRAPH_SIZE]/100.f),
					map(xMin, xMax, (float)(i+1)/GRAPH_SIZE),
					map(yMin, yMax, graph[(step+i+2)%GRAPH_SIZE]/100.f)
			);
		
		GL11.glColor3f(0.2f, 0.0f, 1.2f);

		for(int i=0; i<GRAPH_SIZE-1; i++)
			drawLine(
					map(xMin, xMax, (float)i/GRAPH_SIZE),
					map(yMin, yMax, graph2[(step+i+1)%GRAPH_SIZE]/10000.f),
					map(xMin, xMax, (float)(i+1)/GRAPH_SIZE),
					map(yMin, yMax, graph2[(step+i+2)%GRAPH_SIZE]/10000.f)
			);
		
		
		step = (step+1)%GRAPH_SIZE;
	}
	
	public float map(float low, float high, float value) {
		return low + ((high-low)*value);
	}
	
	public void drawLine(float x1, float y1, float x2, float y2) {
		GL11.glBegin(GL11.GL_LINE_STRIP);
		
		GL11.glVertex2d(x1, y1);
		GL11.glVertex2d(x2, y2);
		GL11.glEnd();
		
	}
	
	public void run() {
		System.out.println("Hello LWJGL " + Version.getVersion() + "!");
		
		init();
		loop();
		
		// Free the window callbacks and destroy the window
		glfwFreeCallbacks(window);
		glfwDestroyWindow(window);
		
		// Terminate GLFW and free the error callback
		glfwTerminate();
		glfwSetErrorCallback(null).free();
	}
	
	
	
	public static void main(String[] args) {
		Main main = new Main();
//		System.out.println(main.self.createPid().toString());
 		main.run();
	}
	
}


