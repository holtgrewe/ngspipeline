/**
 * Helper class that is used for generating paths for files in the pipeline relative to a base directory.
 * 
 * @author Manuel Holtgrewe <manuel.holtgrewe@charite.de>
 */
class PipelinePaths {
	public final String baseDir;
	
	PipelinePaths(String baseDir) {
		this.baseDir = baseDir;
	}

	def reportPath(token, pairID) {
		return [this.baseDir, "reports", token].join(File.separator)
	}

	/**
	 * @param pairID identifier to use for the pair 
	 * @param tag    token to use for path generation, appended to "reports/fastqc" with delimiter "-".
	 */
	def fastqcPath(tag, pairID) {
		def token = "fastqc-" + tag;
		return [this.baseDir, "reports", token].join(File.separator)
	}
	
	/**
	 * @param tag   token to use for path generation below the "fastq" folder, e.g. "original"
	 * @param reads token to use for identifying the reads, e.g. "R1", or "R2"
	 */
	def fastqPattern(tag, reads) {
		return [this.baseDir, "fastq", tag, String.format("*%s*", reads)].join(File.separator)
	}

	/**
	 * @param tag      token to use for path generation below the fastq folder, e.g. "original"
	 * @param basename base name
	 */
	def fastqPath(tag, basename) {
		return [this.baseDir, "fastq", tag, basename].join(File.separator)
	}
	
	def _helper(token, basename, infix = null) {
		if (infix == null || infix.equals(""))
			return [this.baseDir, token, basename.toString()].join(File.separator)
		def tokens = basename.toString().tokenize(".");
		def arr = tokens.collate(tokens.size() - 1);
		tokens = arr[0] + [infix] + arr[1];
		return [this.baseDir, token, tokens.join(".")].join(File.separator)
	}
	
	def bamPath(basename, infix = null) {
		return _helper("bam", basename, infix);
	}
	
	def vcfPath(basename, infix = null) {
		return _helper("vcf", basename, infix);
	}
	
	/**
	 * @param tag token to use for the path generation below.
	 */
	def logPath(tag) {
		return [this.baseDir, "log", tag].join(File.separator)
	}
}