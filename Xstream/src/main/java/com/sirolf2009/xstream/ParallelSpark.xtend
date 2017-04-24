package com.sirolf2009.xstream

import java.util.List
import org.apache.spark.api.java.JavaPairRDD
import org.apache.spark.api.java.JavaRDD
import org.apache.spark.api.java.function.Function
import scala.Tuple2
import org.apache.spark.api.java.function.Function2
import org.apache.spark.api.java.function.VoidFunction

class ParallelSpark {

	def static <T, R> JavaRDD<R> ->(JavaRDD<T> stream, Function<T, R> mapper) {
		return stream.map(mapper)
	}

	def static <K, V, R> JavaRDD<R> ->(JavaPairRDD<K, V> stream, Function<Tuple2<K, V>, R> mapper) {
		return stream.map(mapper)
	}

	def static <T> JavaRDD<T> <>(JavaRDD<T> stream, Function<T, Boolean> filter) {
		return stream.filter(filter)
	}

	def static <T> T =>(JavaRDD<T> stream, Function2<T, T, T> reducer) {
		return stream.reduce(reducer)
	}
	
	def static <T, R> JavaPairRDD<R, Iterable<T>> <=>(JavaRDD<T> stream, Function<T, R> grouper) {
		return stream.groupBy(grouper)
	}

	def static <T> ?:(JavaRDD<T> stream, VoidFunction<T> forEacher) {
		stream.foreach(forEacher)
	}

	def static <T> JavaRDD<T> --(JavaRDD<Iterable<T>> stream) {
		return stream.flatMap[iterator]
	}

	def static <T> List<T> ++(JavaRDD<T> stream) {
		return stream.collect()
	}
	
}