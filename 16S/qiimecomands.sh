# This file contains all the commands used in the study.

# 0 Visualize Qiime visualizations

qiime tools view qiimevisualization.qzv

# 1 Import Phylogenetic Trees

qiime tools import \
  --input-path gg_13_8_otus/trees/97_otus.tree \
  --output-path unrooted-tree.qza \
  --type 'Phylogeny[Unrooted]'

# 2 Root Unrooted Tree

qiime phylogeny midpoint-root \
  --i-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza
  --type 'Phylogeny[Rooted]'

# 3 Import Per-feature unaligned Sequence Data

qiime tools import \
  --input-path gg_13_8_otus/rep_set/97_otus.fasta  \
  --output-path sequences.qza \
  --type 'FeatureData[Sequence]'

# 4 Import Data

qiime tools import   --type 'SampleData[PairedEndSequencesWithQuality]'   --input-path manifest.tsv   --output-path allsamplesimport.qza   --input-format PairedEndFastqManifestPhred33V2

# 5 Visualize data

qiime demux summarize \
  --i-data allsamplesimport.qza \
  --o-visualization allsamplesimport.qzv \

# 6 Deblur pt1

qiime quality-filter q-score \
 --i-demux allsamplesimport.qza \
 --o-filtered-sequences allsamplesimportdemux-filtered.qza \
 --o-filter-stats allsamplesimportdemux-filter-stats.qza

# 7 Deblur pt2

qiime deblur denoise-16S \
  --i-demultiplexed-seqs allsamplesimportdemux-filtered.qza \
  --p-trim-length 220 \
  --o-representative-sequences allsamplesimportrep-seqs-deblur.qza \
  --o-table allsamplesimporttable-deblur.qza \
  --p-sample-stats \
  --o-stats allsamplesimportdeblur-stats.qza

# 8 Deblur pt3

qiime metadata tabulate \
  --m-input-file allsamplesimportdemux-filter-stats.qza \
  --o-visualization allsamplesimportdemux-filter-stats.qzv

qiime deblur visualize-stats \
  --i-deblur-stats allsamplesimportdeblur-stats.qza \
  --o-visualization allsamplesimportdeblur-stats.qzv


# 5 Feature table & feature data

qiime feature-table summarize \
  --i-table seaurchinfeaturetable.qza \
  --o-visualization seaurchinfeaturetable.qzv \
  --m-sample-metadata-file SeaUrchinMetadataQiime2.tsv
    
qiime feature-table tabulate-seqs \
  --i-data sequences.qza \
  --o-visualization sequences.qzv



#  8 Diversity (alpha & beta)

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny 97_otus.qza \
  --i-table seaurchinfeaturetable.qza \
  --p-sampling-depth 2762 \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv \
  --output-dir core-metrics-results




# 9 Exploring Microbial Composition with metadata

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv
  
  
qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv



# 10 PERMANOVA
by Reef Habitat

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv  \
  --m-metadata-column Reef_Habitat \
  --o-visualization core-metrics-results/unweighted-unifrac-reefhabitat-significance.qzv \
  --p-pairwise
 

by Current:

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv  \
  --m-metadata-column Current \
  --o-visualization core-metrics-results/unweighted-unifrac-current-significance.qzv \
  --p-pairwise
  
  by Sargassum

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv  \
  --m-metadata-column Sargassum \
  --o-visualization core-metrics-results/unweighted-unifrac-sargassum-significance.qzv \
  --p-pairwise
 

by Relative_Gut_Content

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv  \
  --m-metadata-column Relative_Gut_Content \
  --o-visualization core-metrics-results/unweighted-unifrac-Relative_Gut_Content-significance.qzv \
  --p-pairwise

  
  # 11 Extension of step 8
numerical

qiime emperor plot \
  --i-pcoa core-metrics-results/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv \
  --p-custom-axes Size \
  --o-visualization core-metrics-results/unweighted-unifrac-emperor-size.qzv

qiime emperor plot \
  --i-pcoa core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv \
  --p-custom-axes Size \
  --o-visualization core-metrics-results/bray-curtis-emperor-size.qzv




# 12 Alpha rarefaction plotting

qiime diversity alpha-rarefaction \
  --i-table seaurchinfeaturetable.qza \
  --i-phylogeny 97_otus.qza \
  --p-max-depth 2762 \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv \
  --o-visualization alpha-rarefaction.qzv



# 13 Taxonomic Analysis

Training Feature Classifiers: recomended to train classifiers with own sequences.
https://docs.qiime2.org/2020.2/data-resources/

Used: Greengenes 13_8 99% OTUs from 515F/806R region of sequences (MD5: 6df67fb01e2f3305e76c61a1c16136b4)

qiime feature-classifier classify-sklearn \
  --i-classifier gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads sequences.qza \
  --o-classification taxonomy.qza

qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv
  
qiime taxa barplot \
  --i-table seaurchinfeaturetable.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file SeaUrchinMetadataQiime2.tsv \
  --o-visualization taxa-bar-plots.qzv


#14 group by location
qiime feature-table group --i-table seaurchinfeaturetable.qza  --p-axis sample  --m-metadata-file SeaUrchinMetadataQiime2.tsv  --m-metadata-column Location  --p-mode sum  

OUTPUT: grouped_table.qza
This is the same as seaurchinfeaturetable.qza
Summarize:
qiime feature-table summarize \
  --i-table grouped_table.qza \
  --o-visualization grouped_table.qzv \
  --m-sample-metadata-file SeaUrchinMetadataQiime2.tsv #####the location ids are not present in the metadata

2. Taxonomy 
qiime taxa barplot \
  --i-table grouped_table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file grouped_meta.tsv \
  --o-visualization grouped-taxa-bar-plots.qzv



## OTHER USEFUL COMMANDS

	#  Adding Metadata
	biom add-metadata -i allsamplesimport.qza -o allsamplesseaurchintable.qza --observation-metadata-fp metadata.tsv

	
qiime metadata tabulate \
 	 --m-input-file metadata.tsv \
 	 --m-input-file allsamplesimport.qza \
 	 --o-visualization allsamplemetadata.qzv


	#  Import Biom table

	qiime tools import \
 	 --input-path seaurchintable.biom \
 	 --type 'FeatureTable[Frequency]' \
 	 --input-format BIOMV210Format \
 	 --output-path seaurchinfeaturetable.qza



