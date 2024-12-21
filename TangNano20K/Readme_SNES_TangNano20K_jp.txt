      SNES on FPGA feat. TangNano20K
                                         by pgate1

・概要

SNES（サウンドDSP除外）を実装しています。
ロックマンX、FFV、バハムートラグーン、クロノトリガー、等が動作します。

・使用方法

microSDHCカードにROMを書き込んで、Tang Nano 20K にセットしてください
（セーブデータがある場合は２番目に書き込んでください）。
microSDHCカードは4GB～32GBのFAT32でフォーマットされたものをサポートしています。

Tang Nano 20K とPCをUSBケーブルで接続後、
SNES.fsをSRAMモードで書き込んでください。

・操作

S1ボタンにStartとAボタンを割り当てています。
S2ボタンはリセットです。

・更新履歴


Ver.20241221
　APUメモリもSDRAMに共存させるようにした。
Ver.20240223
　microSDHCカードとFAT32ファイルシステムに変更。
Ver.20240103
　Tang Nano 20K 用に移植。

==============================================================
転載及び販売を禁止しています。
Web https://pgate1.at-ninja.jp
X(Twitter) https://twitter.com/pgate1
