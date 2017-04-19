package com.sirolf2009.xstream

import java.util.concurrent.atomic.AtomicInteger
import java.util.stream.Collectors
import junit.framework.Assert
import org.junit.Test

import static extension com.sirolf2009.xstream.ParallelStreams.*

class ParallelStreamsTest {
	
	static val list = #[1, 2, 3, 4, 5, 6, 7, 8, 9]
	
	@Test
	def void map() {
		val stream = list.stream -> [it + 1]
		Assert.assertFalse(stream.isParallel())
		Assert.assertEquals(#[2, 3, 4, 5, 6, 7, 8, 9, 10], stream.collect(Collectors.toList))
	}
	
	@Test
	def void mapInstant() {
		val stream = list >> [it + 1]
		Assert.assertFalse(stream.isParallel())
		Assert.assertEquals(#[2, 3, 4, 5, 6, 7, 8, 9, 10], stream.collect(Collectors.toList))
	}
	
	@Test
	def void mapInstantParallel() {
		val stream = list >>> [it + 1]
		Assert.assertTrue(stream.isParallel())
		Assert.assertEquals(#[2, 3, 4, 5, 6, 7, 8, 9, 10], stream.sorted.collect(Collectors.toList))
	}
	
	@Test
	def void filter() {
		val stream = list >> [it] <> [it % 2 == 0]
		Assert.assertFalse(stream.isParallel())
		Assert.assertEquals(#[2, 4, 6, 8], stream.collect(Collectors.toList))
	}
	
	@Test
	def void filterInstant() {
		val stream = list <> [it % 2 == 0]
		Assert.assertFalse(stream.isParallel())
		Assert.assertEquals(#[2, 4, 6, 8], stream.collect(Collectors.toList))
	}
	
	@Test
	def void reduce() {
		val reduced = list >> [it] => [a,b| a+b]
		Assert.assertTrue(reduced.isPresent())
		Assert.assertEquals(45, reduced.get())
	}
	
	@Test
	def void reduceInstant() {
		val reduced = list => [a,b| a+b]
		Assert.assertTrue(reduced.isPresent())
		Assert.assertEquals(45, reduced.get())
	}
	
	@Test
	def void forEach() {
		val counter = new AtomicInteger()
		list >> [it] ?: [
			counter.getAndIncrement()
		]
		Assert.assertEquals(list.size, counter.get())
	}
	
	@Test
	def void forEachInstant() {
		val counter = new AtomicInteger()
		list ?: [
			counter.getAndIncrement()
		]
		Assert.assertEquals(list.size, counter.get())
	}
	
	@Test
	def void groupingBy() {
		val map = list >> [it] <=> [it % 2 == 0]
		val expected = #{
			true -> #[2, 4, 6, 8],
			false -> #[1, 3, 5, 7, 9]
		}
		Assert.assertEquals(expected, map)
	}
	
	@Test
	def void groupingByInstant() {
		val map = list <=> [it % 2 == 0]
		val expected = #{
			true -> #[2, 4, 6, 8],
			false -> #[1, 3, 5, 7, 9]
		}
		Assert.assertEquals(expected, map)
	}
	
	@Test
	def void flatten() {
		val map = list <=> [it % 2 == 0]
		val flattened = (map.entrySet >> [
			if(key) {
				return value >> ['''The number «it» is even''']
			} else {
				return value >> ['''The number «it» is odd''']
			}
		]) --
		val expected = #[
			"The number 1 is odd",
			"The number 2 is even",
			"The number 3 is odd",
			"The number 4 is even",
			"The number 5 is odd",
			"The number 6 is even",
			"The number 7 is odd",
			"The number 8 is even",
			"The number 9 is odd"
		]
		Assert.assertEquals(expected, flattened.sorted().collect(Collectors.toList))
	}
	
	@Test
	def void toList() {
		val collected = (list >> [it + 1]) ++
		Assert.assertEquals(#[2, 3, 4, 5, 6, 7, 8, 9, 10], collected)
	}
	
}