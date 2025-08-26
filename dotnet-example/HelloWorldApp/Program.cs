using System;

namespace HelloWorldApp
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("Hello from GitHub Actions .NET Template!");
            Console.WriteLine($"Current time: {DateTime.Now:yyyy-MM-dd HH:mm:ss}");
            
            if (args.Length > 0)
            {
                Console.WriteLine($"Arguments received: {string.Join(", ", args)}");
            }
            
            var calculator = new Calculator();
            int result = calculator.Add(5, 3);
            Console.WriteLine($"Calculator test: 5 + 3 = {result}");
        }
    }
    
    public class Calculator
    {
        public int Add(int a, int b)
        {
            return a + b;
        }
        
        public int Subtract(int a, int b)
        {
            return a - b;
        }
        
        public int Multiply(int a, int b)
        {
            return a * b;
        }
        
        public double Divide(int a, int b)
        {
            if (b == 0)
                throw new DivideByZeroException("Cannot divide by zero");
            return (double)a / b;
        }
    }
}
