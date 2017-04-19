package com.sirolf2009.xstream

import java.util.concurrent.Executors
import junit.framework.Assert
import org.junit.Test

import static extension com.sirolf2009.xstream.ParallelExecutors.*

class ParallelExecutorsTest {
	
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
	
}