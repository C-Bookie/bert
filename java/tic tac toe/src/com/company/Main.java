package com.company;



import com.ericsson.otp.erlang.*;


import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.RenderingHints;
import java.awt.Stroke;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import javax.swing.*;

public class Main extends JPanel {
	private static final int MAX_SCORE = 20;
	private static final int PREF_W = 800;
	private static final int PREF_H = 650;
	private static final int BORDER_GAP = 30;
	private static final Color GRAPH_COLOR = Color.green;
	private static final Color GRAPH_POINT_COLOR = new Color(150, 50, 50, 180);
	private static final Stroke GRAPH_STROKE = new BasicStroke(3f);
	private static final int GRAPH_POINT_WIDTH = 12;
	private static final int Y_HATCH_CNT = 10;
	private int scores;
	
	private Random rand;
	
	public Main() {
		//scores = getScore();
		scores = 5;
	}
	
	public int getScore() {
		
		rand = new Random();
		
		OtpNode node = null;
		try {
			node = new OtpNode("gurka");
//            node.setCookie("moo");    //no idea what it dose
			OtpMbox mbox = node.createMbox("ttt");
			if (mbox.ping("bert", 1000)) {
				
				//    mbox.link("bert");    //apparently I use to know what this did
				
				OtpErlangObject[] msg = new OtpErlangObject[2];
				msg[0] = mbox.self();
				msg[1] = new OtpErlangAtom("hello, world");
				OtpErlangTuple tuple = new OtpErlangTuple(msg);
				
				mbox.send("game", "bert",tuple);
				System.out.println("yay");
				
				OtpErlangLong o = (OtpErlangLong)mbox.receive();
				System.out.println(o.toString());
				return o.intValue();
			}
			else
				System.out.println("nay");
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		return -1;
	}
	

	protected void paintComponent(Graphics g) {
		super.paintComponent(g);
		Graphics2D g2 = (Graphics2D)g;
		g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
		
		double xScale = ((double) getWidth() - 2 * BORDER_GAP) / (scores - 1);
		double yScale = ((double) getHeight() - 2 * BORDER_GAP) / (MAX_SCORE - 1);
		
		
		// create x and y axes
		g2.drawLine(BORDER_GAP, getHeight() - BORDER_GAP, BORDER_GAP, BORDER_GAP);
		g2.drawLine(BORDER_GAP, getHeight() - BORDER_GAP, getWidth() - BORDER_GAP, getHeight() - BORDER_GAP);
		
		// create hatch marks for y axis.
		for (int i = 0; i < Y_HATCH_CNT; i++) {
			int x0 = BORDER_GAP;
			int x1 = GRAPH_POINT_WIDTH + BORDER_GAP;
			int y0 = getHeight() - (((i + 1) * (getHeight() - BORDER_GAP * 2)) / Y_HATCH_CNT + BORDER_GAP);
			int y1 = y0;
			g2.drawLine(x0, y0, x1, y1);
		}
		
		// and for x axis
		for (int i = 0; i < scores - 1; i++) {
			int x0 = (i + 1) * (getWidth() - BORDER_GAP * 2) / (scores - 1) + BORDER_GAP;
			int x1 = x0;
			int y0 = getHeight() - BORDER_GAP;
			int y1 = y0 - GRAPH_POINT_WIDTH;
			g2.drawLine(x0, y0, x1, y1);
		}
		
		g2.draw3DRect(100, 100, rand.nextInt(100), rand.nextInt(100), false);
		
	}
	
	public Dimension getPreferredSize() {
		return new Dimension(PREF_W, PREF_H);
	}
	
	private static void createAndShowGui() {
		Main mainPanel = new Main();
		
		JFrame frame = new JFrame("DrawGraph");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().add(mainPanel);
		frame.pack();
		frame.setVisible(true);

		try {
			while (true) {
				Thread.sleep(1000);
				mainPanel.repaint();
				SwingUtilities.updateComponentTreeUI(frame);
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

	}
	
	public static void main(String[] args) {
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				createAndShowGui();
			}
		});
	}
}

