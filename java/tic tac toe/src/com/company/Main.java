package com.company;

import com.ericsson.otp.erlang.*;


public class Main {

    public static void main(String[] args) {
        OtpNode node = null;
        try {
            node = new OtpNode("gurka");
//            node.setCookie("moo");    //no idea what it dose
            OtpMbox mbox = node.createMbox("ttt");
            if (mbox.ping("bert", 1000)) {

            //    mbox.link("bert");

                OtpErlangObject[] msg = new OtpErlangObject[2];
                msg[0] = mbox.self();
                msg[1] = new OtpErlangAtom("hello, world");
                OtpErlangTuple tuple = new OtpErlangTuple(msg);

                mbox.send("game", "bert",tuple);
                System.out.println("yay");
            }
            else
                System.out.println("nay");

            OtpErlangAtom o = (OtpErlangAtom)mbox.receive();
            System.out.println(o.toString());

        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}



