# This file contains all the commands used in the study.

# 0 Visualize Qiime visualizations

qiime tools view qiimevisualization.qzv


# 1 Import Data

qiime tools import   
  --type 'SampleData[PairedEndSequencesWithQuality]'   \
  --input-path manifest.tsv   \
  --output-path allsamplesimport.qza   \
  --input-format PairedEndFastqManifestPhred33V2  \

# 2 Visualize data

qiime demux summarize \
  --i-data allsamplesimport.qza \
  --o-visualization allsamplesimport.qzv \

# 3 Filter

qiime quality-filter q-score \
 --i-demux allsamplesimport.qza \
 --o-filtered-sequences allsamplesimportdemux-filtered.qza \ 
 --o-filter-stats allsamplesimportdemux-filter-stats.qza

# 4 Deblur & Generate FeatureTable 

qiime deblur denoise-16S \
  --i-demultiplexed-seqs allsamplesimportdemux-filtered.qza \
  --p-trim-length 220 \
  --o-representative-sequences allsamplesimportrep-seqs-deblur.qza \
  --o-table allsamplesimporttable-deblur.qza \
  --p-sample-stats \
  --o-stats allsamplesimportdeblur-stats.qza

# 5 Summary Stats

qiime metadata tabulate \
  --m-input-file allsamplesimportdemux-filter-stats.qza \
  --o-visualization allsamplesimportdemux-filter-stats.qzv

qiime deblur visualize-stats \
  --i-deblur-stats allsamplesimportdeblur-stats.qza \
  --o-visualization allsamplesimportdeblur-stats.qzv

# 6 Summary Feature Table & Feature Sequence Data

qiime feature-table summarize \
  --i-table allsamplesimporttable-deblur.qza \
  --o-visualization seaurchinfeaturetableallsamples.qzv \
  --m-sample-metadata-file metadata.tsv
    
qiime feature-table tabulate-seqs \
  --i-data allsamplesimportrep-seqs-deblur.qza \
  --o-visualization sequences.qzv

# 7 Generate a tree for Phylogenetic Diversity

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences allsamplesimportrep-seqs-deblur.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza

#  8 Diversity (Alpha & Beta) [p-sampling-depth 2603 taken from seaurchinfeaturetableallsamples.qzv as the minimum frequency]

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table allsamplesimporttable-deblur.qza \
  --p-sampling-depth 2603 \
  --m-metadata-file metadata.tsv \
  --output-dir core-metrics-results

# 9 Exploring Microbial Composition with metadata

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv
  
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv

# 10a PERMANOVA by Reef_Habitat

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv  \
  --m-metadata-column Reef_Habitat \
  --o-visualization core-metrics-results/unweighted-unifrac-reefhabitat-significance.qzv \
  --p-pairwise
 
# 10b PERMANOVA by Location

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv  \
  --m-metadata-column Location \
  --o-visualization core-metrics-results/unweighted-unifrac-location-significance.qzv \
  --p-pairwise


 # 11 Emperor Plots by Metadata: Size

qiime emperor plot \
  --i-pcoa core-metrics-results/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file metadata.tsv \
  --p-custom-axes Size \
  --o-visualization core-metrics-results/unweighted-unifrac-emperor-size.qzv

qiime emperor plot \
  --i-pcoa core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file metadata.tsv \
  --p-custom-axes Size \
  --o-visualization core-metrics-results/bray-curtis-emperor-size.qzv


# 12 Alpha Rarefaction Plotting (median freq number from feature table recommended)

qiime diversity alpha-rarefaction \
  --i-table allsamplesimporttable-deblur.qza \
  --i-phylogeny rooted-tree.qza \
  --p-max-depth 5677 \
  --m-metadata-file metadata.tsv \
  --o-visualization alpha-rarefaction.qzv


# 13 Taxonomic Analysis - Greengenes 13_8 99% OTUs from 515F/806R region of sequences (MD5: 682be39339ef36a622b363b8ee2ff88b)

qiime feature-classifier classify-sklearn \
  --i-classifier gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads allsamplesimportrep-seqs-deblur.qza \
  --o-classification taxonomy.qza

qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv
  
qiime taxa barplot \
  --i-table allsamplesimporttable-deblur.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization taxa-bar-plots.qzv


#14 Group by location
qiime feature-table group 
  --i-table allsamplesimporttable-deblur.qza  \
  --p-axis sample  \
  --m-metadata-file metadata.tsv  \
  --m-metadata-column Location  \
  --p-mode sum  \
  --o-grouped-table locationseaurchintable.qza \


#15 Taxonomy 
qiime taxa barplot \
  --i-table locationseaurchintable.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file grouped_meta_location.tsv \
  --o-visualization grouped-taxa-bar-plots.qzv



