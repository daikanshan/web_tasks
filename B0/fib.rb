#简单实现基本功能
def fib(max_num,fib_val=[1,1])
	i = 3;
  swp1 = 1
  swp2 = 1
  sum  = 1
  while i <= max_num do 
    sum = swp1+swp2
    swp1 = swp2
    swp2 = sum
	  fib_val.push(sum)
    i+=1
  end
	fib_val
end
fib_val=fib(100)
while true do
	puts "请输入1-100之间的数"
	num = STDIN.gets
	begin
		if(num.to_i.to_s!=num.chomp)
			raise "不是整数！"
		elsif(num.to_i>100||num.to_i<=0)
			raise "不在有效范围内"
		else
			(1..num.to_i).each do |i|
				puts "fib(#{i})=#{fib_val[i-1]}"
			end
		end
	rescue => e
		puts e.message
		next
	end
end

