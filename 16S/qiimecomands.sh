# This file contains all the commands used in the study.

# 0 Visualize Qiime visualizations

qiime tools view qiimevisualization.qzv

# 1 Import Data

qiime tools import 
--type 'SampleData[PairedEndSequencesWithQuality]' 
--input-path manifest.tsv 
--output-path allsamplesimport.qza 
--input-format PairedEndFastqManifestPhred33V2  \

#1.5 Join Paired READS
qiime vsearch join-pairs 
--i-demultiplexed-seqs allsamplesimport.qza 
--o-joined-sequences allsamplesimportjoined.qza

qiime demux summarize
--i-data allsamplesimportjoined.qza
--o-visualization allsamplesimportjoined.qzv

#2 Sequence Quality (two options):

#Option 1 Deblur:
#  a.Filter - allsamplesimportdemux-filter.qza is SampleData[SequenceWithQuality] qiime artifact

qiime quality-filter q-score 
--i-demux allsamplesimportjoined.qza 
--o-filtered-sequences allsamplesimportdemux-filter.qza 
--o-filter-stats allsamplesimportdemux-filter-stats.qza

qiime demux summarize
--i-data allsamplesimportdemux-filter.qza 
--o-visualization allsamplesimportdemux-filter.qzv

#  b.Deblur & Generate FeatureTable - --p-trim-length 220 Generates table-deblur.qza FeatureTable[Frequency] and re-seqs-deblur.qza FeatureData[Sequence]

qiime deblur denoise-16S
--i-demultiplexed-seqs allsamplesimportdemux-filter.qza
--p-trim-length 220
--o-representative-sequences allsamplesimportrep-seqs-deblur.qza
--o-table allsamplesimporttable-deblur.qza
--p-sample-stats
--o-stats allsamplesimportdeblur-stats.qza

#Option 2 DADA2 (not used in study):
# a.Denoise
qiime dada2 denoise-single \
  --i-demultiplexed-seqs allsamplesimportjoined.qza \
  --p-trim-left 0 \
  --p-trunc-len 220 \
  --o-representative-sequences allsamplesimportrep-seqs-dada.qza \
  --o-table allsamplesimporttable-dada.qza \
  --o-denoising-stats allsamplesimportdada-stats.qza

#3 Visualize

qiime metadata tabulate
--m-input-file allsamplesimportdemux-filter-stats.qza
--o-visualization allsamplesimportdemux-filter-stats.qzv

qiime deblur visualize-stats
--i-deblur-stats allsamplesimportdeblur-stats.qza
--o-visualization allsamplesimportdeblur-stats.qzv

# 4 Summary Feature Table & Feature Sequence Data

qiime feature-table summarize
--i-table allsamplesimporttable-deblur.qza
--o-visualization seaurchinfeaturetableallsamples.qzv
--m-sample-metadata-file metadata.tsv
    
qiime feature-table summarize
--i-table allsamplesimporttable-deblur.qza
--o-visualization seaurchinfeaturetableallsamples.qzv
--m-sample-metadata-file metadata.tsv

# 5 Generate a tree for Phylogenetic Diversity

qiime phylogeny align-to-tree-mafft-fasttree
--i-sequences allsamplesimportrep-seqs-deblur.qza
--o-alignment aligned-rep-seqs.qza
--o-masked-alignment masked-aligned-rep-seqs.qza 
-o-tree unrooted-tree.qza
--o-rooted-tree rooted-tree.qza


# 6 Alpha Rarefaction Plotting (median freq number from feature table recommended)

qiime diversity alpha-rarefaction
--i-table allsamplesimporttable-deblur.qza
--i-phylogeny rooted-tree.qza --p-max-depth 2189
--m-metadata-file metadata.tsv
--o-visualization alpha-rarefaction.qzv


#  7 Diversity (Alpha & Beta) [p-sampling-depth 704 taken from seaurchinfeaturetableallsamples.qzv as the minimum frequency]

qiime diversity core-metrics-phylogenetic
--i-phylogeny rooted-tree.qza
--i-table allsamplesimporttable-deblur.qza
--p-sampling-depth 704
--m-metadata-file metadata.tsv
--output-dir core-metrics-results

# 8 Exploring Microbial Composition with metadata

qiime diversity alpha-group-significance
--i-alpha-diversity core-metrics-results/faith_pd_vector.qza
--m-metadata-file metadata.tsv
--o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance
--i-alpha-diversity core-metrics-results/evenness_vector.qza
--m-metadata-file metadata.tsv
--o-visualization core-metrics-results/evenness-group-significance.qzv

# 9a PERMANOVA by Reef_Habitat

qiime diversity beta-group-significance
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza
--m-metadata-file metadata.tsv
--m-metadata-column Reef_Habitat
--o-visualization core-metrics-results/unweighted-unifrac-reefhabitat-significance.qzv
--p-pairwise

# 9b PERMANOVA by Location

qiime diversity beta-group-significance
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza
--m-metadata-file metadata.tsv
--m-metadata-column Location
--o-visualization core-metrics-results/unweighted-unifrac-location-significance.qzv
--p-pairwise

# 9c PERMANOVA by Size

qiime diversity beta-group-significance
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza
--m-metadata-file metadata.tsv
--m-metadata-column Size
--o-visualization core-metrics-results/unweighted-unifrac-size-significance.qzv
--p-pairwise

# 9d PERMANOVA by Alignment
qiime diversity beta-group-significance
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza
--m-metadata-file metadata.tsv
--m-metadata-column Alignment
--o-visualization core-metrics-results/unweighted-unifrac-alignment-significance.qzv
--p-pairwise

# 9e PERMANOVA by Current
qiime diversity beta-group-significance
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza
--m-metadata-file metadata.tsv
--m-metadata-column Current
--o-visualization core-metrics-results/unweighted-unifrac-current-significance.qzv
--p-pairwise

# 9c PERMANOVA by Proportion

qiime diversity beta-group-significance
--i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza
--m-metadata-file metadata.tsv
--m-metadata-column Proportion
--o-visualization core-metrics-results/unweighted-unifrac-proportion-significance.qzv
--p-pairwise


#10 Group by Metadata Categories

#10a Location
qiime feature-table group
--i-table allsamplesimporttable-deblur.qza
--p-axis sample
--m-metadata-file metadata.tsv
--m-metadata-column Location
--p-mode sum
--o-grouped-table locationseaurchintable.qza \

#10b Group by Reef Habitat
qiime feature-table group
--i-table allsamplesimporttable-deblur.qza
--p-axis sample
--m-metadata-file metadata.tsv
--m-metadata-column Reef_Habitat
--p-mode sum
--o-grouped-table habitatseaurchintable.qza 

#10c Group by Size
qiime feature-table group
--i-table allsamplesimporttable-deblur.qza
--p-axis sample
--m-metadata-file metadata.tsv
--m-metadata-column Size
--p-mode sum
--o-grouped-table sizeseaurchintable.qza

#10d Group by Alignment
qiime feature-table group
--i-table allsamplesimporttable-deblur.qza
--p-axis sample
--m-metadata-file metadata.tsv
--m-metadata-column Alignment
--p-mode sum
--o-grouped-table alignmentseaurchintable.qza

#10e Group by Current
qiime feature-table group
--i-table allsamplesimporttable-deblur.qza
--p-axis sample
--m-metadata-file metadata.tsv
--m-metadata-column Current
--p-mode sum
--o-grouped-table currentseaurchintable.qza 

#10f Group by Proportion
qiime feature-table group
--i-table allsamplesimporttable-deblur.qza
--p-axis sample
--m-metadata-file metadata.tsv
--m-metadata-column Proportion
--p-mode sum
--o-grouped-table proportionseaurchintable.qza 


# 11 Taxonomic Analysis - Greengenes 13_8 99% OTUs from 515F/806R region of sequences (MD5: 682be39339ef36a622b363b8ee2ff88b)

#11a All Samples
qiime feature-classifier classify-sklearn
--i-classifier gg-13-8-99-515-806-nb-classifier.qza
--i-reads allsamplesimportrep-seqs-deblur.qza
--o-classification taxonomy.qza

qiime metadata tabulate
--m-input-file taxonomy.qza
--o-visualization taxonomy.qzv

qiime taxa barplot
--i-table allsamplesimporttable-deblur.qza
--i-taxonomy taxonomy.qza
--m-metadata-file metadata.tsv
--o-visualization taxa-bar-plots.qzv

#11b Taxonomy by Location
qiime taxa barplot
--i-table locationseaurchintable.qza
--i-taxonomy taxonomy.qza
--m-metadata-file metadata_location.tsv
--o-visualization locationgrouped-taxa-bar-plots.qzv

#11c Taxonomy by Size
qiime taxa barplot
--i-table sizeseaurchintable.qza
--i-taxonomy taxonomy.qza
--m-metadata-file metadata_size.tsv
--o-visualization sizegrouped-taxa-bar-plots.qzv

#11d Taxonomy by Alignment
qiime taxa barplot
--i-table alignmentseaurchintable.qza
--i-taxonomy taxonomy.qza
--m-metadata-file metadata_alignment.tsv
--o-visualization alignmentgrouped-taxa-bar-plots.qzv

#11e Taxonomy by Current
qiime taxa barplot
--i-table currentseaurchintable.qza
--i-taxonomy taxonomy.qza
--m-metadata-file metadata_current.tsv
--o-visualization currentgrouped-taxa-bar-plots.qzv

#11f Taxonomy by Proportion
qiime taxa barplot
--i-table proportionseaurchintable.qza
--i-taxonomy taxonomy.qza
--m-metadata-file metadata_proportion.tsv
--o-visualization proportiongrouped-taxa-bar-plots.qzv

