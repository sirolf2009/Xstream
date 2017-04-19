package com.sirolf2009.xstream

import com.sirolf2009.xstream.ParallelExecutors.Operation
import java.util.concurrent.ExecutorService
import java.util.stream.Stream

class ParallelExecutors {

	def static <T> ||(ExecutorService executor, Operation<T> he) {
		he.call(executor).get()
	}

	def static <T> ||((Object)=>T me, (Object)=>T he) {
		operator_or(me as Operation<T>, he as Operation<T>)
	}

	def static <T> Operation<T> +((Object)=>T me) {
		return me as Operation<T>
	}

	def static <T> ||(Operation<T> me, Operation<T> he) {
		return new Operation<T>() {
			override get(ExecutorService executor) {
				val meF = me.call(executor)
				val heF = he.call(executor)
				val meR = meF.get()
				val heR = heF.get()
				Stream.concat(meR, heR)
			}

			override compute() {
				throw new UnsupportedOperationException("TODO: auto-generated method stub")
			}
		}
	}

	interface Operation<T> {

		def call(ExecutorService executor) {
			executor.submit[get(executor)]
		}

		def Stream<T> get(ExecutorService executor) {
			Stream.of(compute())
		}

		def T compute()

	}

}
