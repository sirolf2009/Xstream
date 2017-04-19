package com.sirolf2009.xstream

import java.util.Collection
import java.util.List
import java.util.Map
import java.util.Optional
import java.util.function.BinaryOperator
import java.util.stream.Collectors
import java.util.stream.Stream

class ParallelStreams {

	/**
	 * Operator meanings:
	 * 
	 * >> stream and map
	 * >>> parallel stream and map
	 * -> map
	 * <> filter
	 * ?: forEach
	 * => reduce
	 * <=> group
	 * ++ collect to list
	 * -- flatten
	 */
	def static void main(String[] args) {
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
	}

	def static <T, R> Stream<R> >>(Collection<T> list, (T)=>R mapper) {
		return list.stream().map(mapper)
	}

	def static <T, R> Stream<R> >>>(Collection<T> list, (T)=>R mapper) {
		return list.parallelStream.map(mapper)
	}

	def static <T> Stream<T> <>(Collection<T> list, (T)=>boolean filter) {
		return list.stream.filter(filter)
	}

	def static <T, R> Stream<R> ->(Stream<T> stream, (T)=>R mapper) {
		return stream.map(mapper)
	}

	def static <T> Stream<T> <>(Stream<T> stream, (T)=>boolean filter) {
		return stream.filter(filter)
	}

	def static <T> Optional<T> =>(Stream<T> stream, BinaryOperator<T> reducer) {
		return stream.reduce(reducer)
	}
	
	def static <T, R> Map<R, List<T>> <=>(Collection<T> list, (T)=>R grouper) {
		return list.stream <=> grouper
	}
	
	def static <T, R> Map<R, List<T>> <=>(Stream<T> stream, (T)=>R grouper) {
		return stream.collect(Collectors.groupingBy(grouper))
	}

	def static <T> ?:(Stream<T> stream, (T)=>void forEacher) {
		stream.forEach(forEacher)
	}

	def static <T> Stream<T> --(Stream<Stream<T>> stream) {
		stream.flatMap[it]
	}

	def static <T> List<T> ++(Stream<T> stream) {
		stream.collect(Collectors.toList)
	}

}
