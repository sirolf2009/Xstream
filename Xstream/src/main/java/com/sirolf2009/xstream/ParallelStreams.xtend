package com.sirolf2009.xstream

import java.util.Collection
import java.util.List
import java.util.Map
import java.util.Optional
import java.util.function.BinaryOperator
import java.util.stream.Collectors
import java.util.stream.Stream

class ParallelStreams {

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

	def static <T> Optional<T> =>(Collection<T> list, BinaryOperator<T> reducer) {
		return list.stream.reduce(reducer)
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

	def static <T> ?:(Collection<T> list, (T)=>void forEacher) {
		list.stream.forEach(forEacher)
	}

	def static <T> Stream<T> --(Stream<Stream<T>> stream) {
		return stream.flatMap[it]
	}

	def static <T> List<T> ++(Stream<T> stream) {
		return stream.collect(Collectors.toList)
	}

}
