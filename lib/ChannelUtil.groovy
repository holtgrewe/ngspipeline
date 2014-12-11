import PathUtil

class ChannelUtil {
	/**
	 * Join the files from two Channels into triples.
	 *
	 * @param left
	 * @param right
	 * @return new Channel of triplet lists [ pairID, leftFile, rightFile ]
	 */
	static def createFilePairChannel(left, right) {
		return left.merge(right) { l, r -> [ PathUtil.lcp(l.toString(), r.toString()), l, r ] }
	}
}