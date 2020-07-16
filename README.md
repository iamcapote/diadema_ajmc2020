# 16s_diadema_ajmc2020
 
This contains all of the data used in the study AJMC 2020.
including qiime commands, etc.


## WORKFLOW


16S rRNA - Qiime2

1. Download and import sequences from diadema_ajmc2020\16S\RawSequences and generate Qiime2 artifacts
2. Download and import phylogenetic trees and references from

http://qiime.org/home_static/dataFiles.html
ftp://greengenes.microbio.me/greengenes_release/gg_13_8_otus/

________________________________________________________________________

CytoB - Geneious & Mega X

1. Download and import sequences from diadema_ajmc2020\CytoB\RawSequences into Geneious.
2. Merge Pair Ends, Trim, Normalize and Error Correct sequences.
3. Generate consensus sequence of all samples using Diadema setosum as a reference from diadema_ajmc2020\CytoB\ReferenceSequences\Diadema_setosum_Cytochrome.fasta to produce diadema_ajmc2020\CytoB\Geneious\ConsensusSeq\ConsensusSequenceofAllSamplesUsingReferenceDiademasetosum.fasta
4. Generate consensus sequences and contigs from each separate sample.
5. Align Consensus Sequences from samples and all references to diadema_ajmc2020\CytoB\Alignments