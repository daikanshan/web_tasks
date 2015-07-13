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
while true do
	puts "请输入1-100之间的数"
	num = STDIN.gets
	begin
		if(!(num.to_i.to_s+"\n"==num))
			raise "不是整数！"
		elsif(num.to_i>100||num.to_i<=0)
			raise "不在有效范围内"
		else
			fib(num.to_i)
		end
	rescue => e
		puts e.message
		next
	end
end

