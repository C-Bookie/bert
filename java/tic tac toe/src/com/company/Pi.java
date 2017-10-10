package com.company;

import com.pi4j.io.gpio.GpioController;
import com.pi4j.io.gpio.GpioFactory;
import com.pi4j.io.gpio.RaspiPin;
import com.pi4j.io.i2c.I2CBus;
import com.pi4j.io.i2c.I2CFactory;

import java.io.IOException;

/**
 * Created by duck- on 08/10/2017.
 */
public class Pi {

    final static int address = 0x32;

	public Pi() {

	}
	
	public static void foo()  throws IOException {
		System.out.println("boo ya");

        Display disp = null;
        try {
            disp = new Display(128, 64, GpioFactory.getInstance(), I2CFactory.getInstance(I2CBus.BUS_1), address, RaspiPin.GPIO_07);
        } catch (I2CFactory.UnsupportedBusNumberException e) {
            e.printStackTrace();
        } catch (ReflectiveOperationException e) {
            e.printStackTrace();
        }

        disp.begin();

		long last, nano = 0;

		for(int x = 0; x < 64; x++) {
			for (int y = 0; y < 64; y++) {
				disp.setPixel(x, y, true);
				last = System.nanoTime();
				disp.display();
				nano += (System.nanoTime() - last);
			}
		}

		System.out.println("Display lasts " + ((nano / 1000000) / (64 * 64)) + " ms");
		
	}

    public static void main(String[] args) {

        try {
            System.out.println("Begin");
            Pi.foo();
        } catch (IOException e) {
            System.out.println("Error");
            e.printStackTrace();
        }
        System.out.println("End");



    }

}