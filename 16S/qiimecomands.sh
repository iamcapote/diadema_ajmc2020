# this file contains all the commands used in the study

# 1 Adding Metadata
biom add-metadata -i table_even2762.biom -o seaurchintable.biom --observation-metadata-fp SeaUrchinMetadataQiime2.tsv

# 3 Import Biom table

qiime tools import \
  --input-path seaurchintable.biom \
  --type 'FeatureTable[Frequency]' \
  --input-format BIOMV210Format \
  --output-path seaurchinfeaturetable.qza


# 4 Import Phylogenetic Trees

qiime tools import \
  --input-path gg_13_8_otus/trees/97_otus.tree \
  --output-path unrooted-tree.qza \
  --type 'Phylogeny[Unrooted]'



# 5 Import Per-feature unaligned Sequence Data

qiime tools import \
  --input-path gg_13_8_otus/rep_set/97_otus.fasta  \
  --output-path sequences.qza \
  --type 'FeatureData[Sequence]'



# 6 Feature table & feature data

qiime feature-table summarize \
  --i-table seaurchinfeaturetable.qza \
  --o-visualization seaurchinfeaturetable.qzv \
  --m-sample-metadata-file SeaUrchinMetadataQiime2.tsv
    
qiime feature-table tabulate-seqs \
  --i-data sequences.qza \
  --o-visualization sequences.qzv



# 7 Root Unrooted Tree

qiime phylogeny midpoint-root \
  --i-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza
  --type 'Phylogeny[Rooted]'
#  in the step 7 fixing error
   "All non-root nodes in ``tree`` must have a branch length.
import skbio"


_______________________
### in python:

1.
t = skbio.TreeNode.read('/home/qiime2/Desktop/QIIME_DATA/core-2762/gg_13_8_otus/trees/97_otus.tree')

2.
for n in t.traverse():
     if n.length is None:
         n.length = 0.0
         
3.
 import qiime2
 
4. 
 ar = qiime2.Artifact.import_data('Phylogeny[Rooted]', t)
 
5.
 ar.save('97_otus.qza')
_______________________


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


