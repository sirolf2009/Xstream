package com.sirolf2009.xstream

import java.io.Serializable
import java.util.concurrent.atomic.AtomicInteger
import junit.framework.Assert
import org.apache.spark.api.java.JavaSparkContext
import org.junit.Test

import static extension com.sirolf2009.xstream.ParallelSpark.*

class ParallelSparkTest {
	
	static val sc = new JavaSparkContext("local[1]", "unit test")

	static class MapUnitTest {
		val list = sc.parallelize(#[1, 2, 3, 4, 5, 6, 7, 8, 9])

		@Test
		def void map() {
			val stream = list -> [it + 1]
			Assert.assertEquals(#[2, 3, 4, 5, 6, 7, 8, 9, 10], stream.collect())
		}
	}

	static class FilterUnitTest {
		val list = sc.parallelize(#[1, 2, 3, 4, 5, 6, 7, 8, 9])

		@Test
		def void filter() {
			val stream = list <> [it % 2 == 0]
			Assert.assertEquals(#[2, 4, 6, 8], stream.collect())
		}
	}

	static class ReduceUnitTest {
		val list = sc.parallelize(#[1, 2, 3, 4, 5, 6, 7, 8, 9])

		@Test
		def void reduce() {
			val reduced = list => [a, b|a + b]
			Assert.assertNotNull(reduced)
			Assert.assertEquals(45, reduced)
		}
	}

	static val counter = new AtomicInteger()
	static class ForEachUnitTest implements Serializable {
		val list = sc.parallelize(#[1, 2, 3, 4, 5, 6, 7, 8, 9])

		@Test
		def void forEach() {
			list ?: [
				counter.getAndIncrement()
			]
			Assert.assertEquals(9, counter.get())
		}
	}

	static class GroupingByUnitTest {
		val list = sc.parallelize(#[1, 2, 3, 4, 5, 6, 7, 8, 9])

		@Test
		def void groupingBy() {
			val map = (list <=> [it % 2 == 0]).collectAsMap
			val expected = #{
				true -> #[2, 4, 6, 8],
				false -> #[1, 3, 5, 7, 9]
			}
			Assert.assertEquals(expected.get(true).toList, map.get(true).toList)
			Assert.assertEquals(expected.get(false).toList, map.get(false).toList)
		}
	}

	static class ToListTest {
		val list = sc.parallelize(#[1, 2, 3, 4, 5, 6, 7, 8, 9])

		@Test
		def void toList() {
			val collected = (list -> [it + 1])++
			Assert.assertEquals(#[2, 3, 4, 5, 6, 7, 8, 9, 10], collected)
		}
	}
	
}
