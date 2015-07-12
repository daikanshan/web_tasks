#简单实现基本功能
def fib(num)
        i = 1;
        swp1 = 1
        swp2 = 1
        sum  = 1
        while i <=num do
                if (i == 1 || i == 2)
                        sum = 1
                else
                        sum = swp1+swp2
                        swp1 = swp2
                        swp2 = sum
                end
                puts "fib(#{i})=#{sum}\n"
                i+=1
        end
end
puts "请输入1-100之间的数"
num = STDIN.gets
fib(num.to_i);

