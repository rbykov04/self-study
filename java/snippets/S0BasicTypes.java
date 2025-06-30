public class S0BasicTypes {
    public static void main(String[] args) {
        {
            byte a = 127;
            //byte b = 128; // compile error

            System.out.println("byte");
            System.out.println("a      = " + a   );
            System.out.println("a + 1  = " + (a + 1)); //converstaion to int
            System.out.println("++a    =" + (++a));    // -128
        }

        {
            short a = Short.MAX_VALUE;
            //short b = 32768; compile error

            System.out.println("short");
            System.out.println("a      = " + a   );
            System.out.println("a + 1  = " + (a + 1)); // conversation to int?
            System.out.println("++a    =" + (++a));    // to MIN_VALUE
        }

        {
            int a = Integer.MAX_VALUE;

            System.out.println("int");
            System.out.println("a      = " + a   );
            System.out.println("a + 1  =" + (a + 1)); // to MIN_VALUE
            System.out.println("++a    =" + (++a));    // to MIN_VALUE
        }

        {
            long a = Long.MAX_VALUE;

            System.out.println("long");
            System.out.println("a      = " + a   );
            System.out.println("a + 1  =" + (a + 1)); // to MIN_VALUE
            System.out.println("++a    =" + (++a));    // to MIN_VALUE
        }

    }

}
