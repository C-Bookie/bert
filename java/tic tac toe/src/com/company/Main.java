package com.company;

import java.io.IOException;

public class Main {
	
	public static void main(String[] args) {
//		Main main = new Main();
//		System.out.println(main.self.createPid().toString());
// 		main.run();
		
		
		Pi pi = new Pi();

		try {
			System.out.println("Begin");
			pi.foo();
		} catch (IOException e) {
			System.out.println("Error");
			e.printStackTrace();
		}
		System.out.println("End");



	}
	
}




