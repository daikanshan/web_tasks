$arr = [
	[3524578,2178309,2178309,1346269], #基础矩阵的32次幂
	[1597,987,987,610],								 #基础矩阵的16次幂
	[34,21,21,13],										 #基础矩阵的8次幂
	[5,3,3,2],												 #基础矩阵的4次幂
	[2,1,1,1],												 #基础矩阵的2次幂
	[1,1,1,0]													 #基础矩阵的1次幂
]
def fib(k)
	if k<3 
	 return 1
	else
		t00,t01,t10,t11 = 1,1,1,0
		a,b,c,d = t00,t01,t10,t11
		k = k-2
		while k>=32 do                    #对于大于等于32次幂的k转换成最多个32次幂的乘方
			a = t00*$arr[0][0]+t01*$arr[0][2]
			b = t00*$arr[0][1]+t01*$arr[0][3]
			c = t10*$arr[0][0]+t11*$arr[0][2]
			d = t10*$arr[0][1]+t11*$arr[0][3]
		 	t00,t01,t10,t11 = a,b,c,d
			k = k-32
		end
		mi = 4
		while mi>=0 do                     #对于小于32次幂的k由大到小转换成最多个16次幂、8次幂、4次幂、2次幂、1次幂的乘方
			if k>=2**mi
				a = t00*$arr[5-mi][0]+t01*$arr[5-mi][2]
				b = t00*$arr[5-mi][1]+t01*$arr[5-mi][3]
				c = t10*$arr[5-mi][0]+t11*$arr[5-mi][2]
				d = t10*$arr[5-mi][1]+t11*$arr[5-mi][3]
		 		t00,t01,t10,t11 = a,b,c,d
				k = k-2**mi
			end
			mi = mi-1
		end
		return t00
	end
end
while true do
	puts "请输入1-100之间的数"
	num = STDIN.gets
	begin
		if(num.to_i.to_s!=num.chomp)      #用户输入非整数或输入为空
			raise "不是整数！"
		elsif(num.to_i>100||num.to_i<=0)  #用户输入的整数不在范围  #用户输入的整数不在范围内内
			raise "不在有效范围内"
		else
			(1..num.to_i).each do |i|
				puts "fib(#{i})=#{fib(i)}"
			end
		end
	rescue => e
		puts e.message
		next
	end
end
