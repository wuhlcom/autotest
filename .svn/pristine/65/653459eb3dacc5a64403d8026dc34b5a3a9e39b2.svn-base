p require 'inline'
# p require 'Rubyinline'
#include <stdlib.h>
#include <stdio.h>

#include <pcap.h>
class A
  inline do |b|
    b.include '<stdio.h>'
    b.flags=["-std=c99"]
    b.c "
    int show(int i,int j)
    {
      return i+j;
    }"

    b.c "int main(void)
    {
        puts(\"hello world!\");
        return 0;
    }"

    b.c 'void fast_inc(long x)
    {
        long long v = 0;
        for(long i=0;i<x;++i)
            for(long j=0;j<x;++j)
                for(long k=0;k<x;++k)
                    v += i+j*k;
                    //printf("now is %ld , %ld , %ld\n",i,j,k);
        printf("v is %lld\n",v);
    }'
  end
end

a = A.new
puts a.show(1,2)
a.main()
a.fast_inc(90000000000000)