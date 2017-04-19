# Xstream
A library for easy parallel executions with Xtend

## Streams
Operator meanings:
	 
* \>\> stream and map
* \>\>\> parallel stream and map
* -> map
* <> filter
* ?: forEach
* => reduce
* <=> group
* ++ collect to list
* -- flatten
   
```xtend
import static extension com.sirolf2009.xstream.ParallelStreams.*

val list = #[1, 2, 3, 4, 5, 6, 7, 8, 9]
		
println("Random calculation:")
list >> [it + 1] <> [it < 10] -> [it * 2] ?: [
	println(it)
]
println()
	
println("Parallel random calculation")
println((list >>> [it + 1] <> [it < 10] -> [it * 2] => [a,b| a+b]).get())
println()
		
println("Even Numbers:")
list <> [it % 2 == 0] -> ['''The number «it» is even'''] ?: [
	println(it)
]
println()
		
println("All numbers")
val map = list <=> [it % 2 == 0]
val strings = (map.entrySet >> [
	if(key) {
		return value >> ['''The number «it» is even''']
	} else {
		return value >> ['''The number «it» is odd''']
	}
]) --
strings.sorted ?: [
	println(it)
]
println()
		
println("Negative numbers")
println((list >> [it*-1]) ++)
```

## Executors
```xtend
import static extension com.sirolf2009.xstream.ParallelExecutors.*

static val executor = Executors.newFixedThreadPool(100)
	
@Test
def void test() {
	val now = System.currentTimeMillis()
	val parallelyExecuted = executor  
		|| ([Thread.sleep(1000) return 1] 
		|| [Thread.sleep(1000) return 2] 
		|| [Thread.sleep(2000) return 3] 
		|| [Thread.sleep(2000) return 4] 
		|| [Thread.sleep(1000) return 5] 
		|| [Thread.sleep(1000) return 6] 
		|| [Thread.sleep(2000) return 7] 
		|| [Thread.sleep(2000) return 8] 
		|| [Thread.sleep(1000) return 9] 
		|| [Thread.sleep(1000) return 10] 
		|| [Thread.sleep(2000) return 11]
		|| [Thread.sleep(2000) return 12])
	
	Assert.assertEquals(78, parallelyExecuted.mapToInt[it].sum())
	Assert.assertTrue((System.currentTimeMillis() - now) > 1999)
	Assert.assertTrue((System.currentTimeMillis() - now) < 2999)
}
 ```
