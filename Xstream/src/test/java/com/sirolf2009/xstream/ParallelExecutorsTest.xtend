package com.sirolf2009.xstream

import java.util.concurrent.Executors
import junit.framework.Assert
import org.junit.Test

import static extension com.sirolf2009.xstream.ParallelExecutors.*
import java.util.concurrent.atomic.AtomicInteger

class ParallelExecutorsTest {
	
	static val executor = Executors.newFixedThreadPool(100)
	
	@Test
	def void testProducer() {
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
	
	@Test
	def void testConsumer() {
		val now = System.currentTimeMillis()
		val counter = new AtomicInteger()
		executor 
		    || ([Thread.sleep(1000) counter.incrementAndGet()] 
			|| [Thread.sleep(1000) counter.incrementAndGet()] 
			|| [Thread.sleep(2000) counter.incrementAndGet()] 
			|| [Thread.sleep(2000) counter.incrementAndGet()] 
			|| [Thread.sleep(1000) counter.incrementAndGet()] 
			|| [Thread.sleep(1000) counter.incrementAndGet()] 
			|| [Thread.sleep(2000) counter.incrementAndGet()] 
			|| [Thread.sleep(2000) counter.incrementAndGet()] 
			|| [Thread.sleep(1000) counter.incrementAndGet()] 
			|| [Thread.sleep(1000) counter.incrementAndGet()] 
			|| [Thread.sleep(2000) counter.incrementAndGet()]
			|| [Thread.sleep(2000) counter.incrementAndGet()])
		Assert.assertEquals(12, counter.get())
		Assert.assertTrue((System.currentTimeMillis() - now) > 1999)
		Assert.assertTrue((System.currentTimeMillis() - now) < 2999)
	}
	
}