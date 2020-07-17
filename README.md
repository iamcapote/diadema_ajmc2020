# 16s_diadema_ajmc2020
 
This contains all of the data used in the study AJMC 2020.
including qiime commands, etc.

## File Tree Directory

```
 |-- diadema_ajmc2020
    |-- 16S
        |-- RawSequences
            |-- AllSamples
            |-- CategSize
        |-- qiimecommands.sh
    |-- CytoB
        |-- Alignments
        |-- Geneious
            |-- ConsensusSeq
            |-- Contigs
            |-- Preparing Samples
        |-- RawSequences
        |-- ReferenceSequences
        |-- Trees
    |-- README.md
    |-- References Thesis.xlx
```
    

## WORKFLOW

#### CytoB - Geneious & Mega X

Learn how to use Geneious: https://www.geneious.com/
https://www.geneious.com/tutorials/

Tutorials used in this study:
https://www.geneious.com/tutorials/de-novo-assembly/
https://www.geneious.com/tutorials/map-to-reference/

Learn how to use Mega X:
https://megasoftware.net/

1. Download and import sequences from diadema_ajmc2020\CytoB\RawSequences into Geneious.

2. Merge Pair Ends, Trim, Normalize and Error Correct sequences.

3. Generate consensus sequence of all samples using Diadema setosum as a reference from diadema_ajmc2020\CytoB\ReferenceSequences\Diadema_setosum_Cytochrome.fasta to produce diadema_ajmc2020\CytoB\Geneious\ConsensusSeq\ConsensusSequenceofAllSamplesUsingReferenceDiademasetosum.fasta

4. Generate consensus sequences and contigs from each separate sample.

5. Align Consensus Sequences from samples and all references to diadema_ajmc2020\CytoB\Alignments generate phylogenetic trees in diadema_ajmc2020\CytoB\Trees

______________________________________________

#### 16S rRNA - Qiime2

Qiime2 Commands used can be found in diadema_ajmc2020\16S\qiimecommands.sh


Tutorial used:
https://docs.qiime2.org/2020.6/tutorials/moving-pictures/

1. Download and import gg_13_8_otus including phylogenetic trees and references from

http://qiime.org/home_static/dataFiles.html

ftp://greengenes.microbio.me/greengenes_release/gg_13_8_otus/

```
    qiime2 artifacts generated: 
        rooted-tree.qza ;
        sequences.qza ;
        unrooted-tree.qza ;
```

2. Download and import sequences from diadema_ajmc2020\16S\RawSequences and generate Qiime2 artifacts

```
    qiime2 artifacts generated: 
        allsamplesimport.qza ; 
        onepointfivesampleimport.qza ; 
        twopointzeroimport.qza ; 
        twopointfiveimport.qza ; 
        threepointzeroimport.qza ; 
        threepointfive.qza ; 
        fourpointfive.qza ;      
```


3. Deblur  
Create Feature Table and Feature Data Artifacts

```
    qiime2 artifacts generated: 
        allsamplesimportdeblur-stats.qza ;
        allsamplesimportdeblur-stats.qzv ;
        allsamplesimportdemux-filter.qza ; SampleData[SequencesWithQuality]
        allsamplesimportdemmux-filter-stats.qza ;
        allsamplesimportdemmux-filter-stats.qzv ;
        allsamplesimportrep-seqs-deblur.qza ; FeatureData[Sequence] 
        allsamplesimportdemmuxtable-deblur.qza ; FeatureTable[Frequency]
                
    ```
________________________________________________________________________