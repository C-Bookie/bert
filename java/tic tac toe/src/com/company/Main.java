package com.company;



import com.ericsson.otp.erlang.*;

//import java.util.Scanner;


public class Main {

    public static void main(String[] args) {
        OtpNode node = null;
        try {
            node = new OtpNode("gurka");
//            node.setCookie("moo");    //no idea what this dose
            OtpMbox mbox = node.createMbox("ttt");
            if (mbox.ping("bert", 1000)) {

            //    mbox.link("bert");

                OtpErlangObject[] msg = new OtpErlangObject[2];
                msg[0] = mbox.self();
                msg[1] = new OtpErlangAtom("hello, world");
                OtpErlangTuple tuple = new OtpErlangTuple(msg);

                mbox.send("game", "bert",tuple);
                System.out.println("yay");
    
                OtpErlangAtom o = (OtpErlangAtom)mbox.receive();
                System.out.println(o.toString());
            }
            else
                System.out.println("nay");

        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

/*    public void tttTets() {
		char state;
		do {
			Scanner reader = new Scanner(System.in);  // Reading from System.in
			System.out.println("Enter a number: ");
			int n = reader.nextInt(); // Scans the next token of the input as an int.
		} while (state)
	}
*/
}


