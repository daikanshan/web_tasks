def getArr(k)#把k分成最少个2的n次幂的形式  如：234=2××7+2××6+2××5+2××3+2××1 记录下[7,6,5,3,1]
		temp = []
		while k!=0
			mi = Math.log(k,2).to_i
			temp<<mi
			k = k-2**mi
		end
		temp
end
def fib(k)
	if k==0
		return 0
	end
	if k<3 
	 return 1
	else
		k = k-1
		arr = getArr k
		t00,t01,t10,t11 = 1,1,1,0 #基础矩阵
		a,b,c,d = t00,t01,t10,t11
		fa,fb,fc,fd = 1,0,0,1 #初始矩阵（处理getArr==[0]）也作为最终结果的矩阵
		max = Math.log(k,2).to_i
		bgn = 0
		while bgn<=max  #计算基础矩阵的n次幂
			if arr.include?bgn #如果当前的bgn在getArr[k]中，则直接将其纳入最终结果的计算
				ta = fa*t00+fb*t10
				tb = fa*t01+fb*t11
				tc = fc*t00+fd*t10
				td = fc*t01+fd*t11
				fa,fb,fc,fd = ta,tb,tc,td
			end
			a = t00*t00+t01*t10
			b = t00*t01+t01*t11
			c = t10*t00+t11*t10
			d = t10*t01+t11*t11
		 	t00,t01,t10,t11 = a,b,c,d
			bgn = bgn+1
		end
		return fa
	end
end
while true do
	puts "输入n、m,计算fib(n)-fib(m)"
	puts "输入n："
	n = gets
	puts "输入m："
	m = gets
	begin
		if(n.to_i.to_s!=n.chomp||m.to_i.to_s!=m.chomp)      #用户输入非整数或输入为空
			raise "不是整数！"
		elsif(n.to_i>100||n.to_i<=0||m.to_i>100||m.to_i<=0)  #用户输入的整数不在范围  #用户输入的整数不在范围内内
			raise "不在有效范围内"
		else
			if n.to_i>=m.to_i
				n,m = m,n
			end
			fn = fib(n.to_i)
			fm = fib(n.to_i-1)
			puts "fib(#{n.to_i})=#{fn}"
			((n.to_i+1)..(m.to_i)).each do |i|
				puts "fib(#{i})=#{fm+fn}"
				fm,fn=fn,fm+fn
			end
		end
	rescue => e
		puts e.message
		next
	end
end
