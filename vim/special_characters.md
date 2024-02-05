
# Special Characters in Vim

## Digraphs  
* `:h dig` | `digraphs`  
  
Digraphs are special characters that can be inserted (while in insert mode) with `<C-k>xx` where  
`xx` is a key combination for a given `digraph`.  

There are two ways to insert digraph characters:
1. `Ctrl-K`: 
    * While in insert mode, press `<C-k>` followed by the two characters that make up the
      digraph, shown to the left of each digraph in `:digraphs`.  
2. `Ctrl-Q` (Windows) or `Ctrl-V` (Unix/Linux):
    * While in insert mode, press `<C-q>` or `<C-v>` followed by the digits that make up the 
      digraph, shown to the right of each digraph in `:digraphs`.  

### List of Digraphs
```digraphs
dH ┯  9519   Dh ┰  9520   DH ┳  9523   uh ┴  9524   uH ┷  9527   Uh ┸  9528   UH ┻  9531
vh ┼  9532   vH ┿  9535   Vh ╂  9538   VH ╋  9547   FD ╱  9585   BD ╲  9586   TB ▀  9600
LB ▄  9604   FB █  9608   lB ▌  9612   RB ▐  9616   .S ░  9617   :S ▒  9618   ?S ▓  9619
fS ■  9632   OS □  9633   RO ▢  9634   Rr ▣  9635   RF ▤  9636   RY ▥  9637   RH ▦  9638
RZ ▧  9639   RK ▨  9640   RX ▩  9641   sB ▪  9642   SR ▬  9644   Or ▭  9645   UT ▲  9650
uT △  9651   PR ▶  9654   Tr ▷  9655   Dt ▼  9660   dT ▽  9661   PL ◀  9664   Tl ◁  9665
Db ◆  9670   Dw ◇  9671   LZ ◊  9674   0m ○  9675   0o ◎  9678   0M ●  9679   0L ◐  9680
0R ◑  9681   Sn ◘  9688   Ic ◙  9689   Fd ◢  9698   Bd ◣  9699   *2 ★  9733   *1 ☆  9734
<H ☜  9756   >H ☞  9758   0u ☺  9786   0U ☻  9787   SU ☼  9788   Fm ♀  9792   Ml ♂  9794
cS ♠  9824   cH ♡  9825   cD ♢  9826   cC ♣  9827   Md ♩  9833   M8 ♪  9834   M2 ♫  9835
Mb ♭  9837   Mx ♮  9838   MX ♯  9839   OK ✓  10003  XX ✗  10007  -X ✠  10016  IS 　 12288
,_ 、 12289  ._ 。 12290  +" 〃 12291  +_ 〄 12292  *_ 々 12293  ;_ 〆 12294  0_ 〇 12295
<+ 《 12298  >+ 》 12299  <' 「 12300  >' 」 12301  <" 『 12302  >" 』 12303  (" 【 12304
)" 】 12305  =T 〒 12306  =_ 〓 12307  (' 〔 12308  )' 〕 12309  (I 〖 12310  )I 〗 12311
-? 〜 12316  A5 ぁ 12353  a5 あ 12354  I5 ぃ 12355  i5 い 12356  U5 ぅ 12357  u5 う 12358
E5 ぇ 12359  e5 え 12360  O5 ぉ 12361  o5 お 12362  ka か 12363  ga が 12364  ki き 12365
gi ぎ 12366  ku く 12367  gu ぐ 12368  ke け 12369  ge げ 12370  ko こ 12371  go ご 12372
sa さ 12373  za ざ 12374  si し 12375  zi じ 12376  su す 12377  zu ず 12378  se せ 12379
ze ぜ 12380  so そ 12381  zo ぞ 12382  ta た 12383  da だ 12384  ti ち 12385  di ぢ 12386
tU っ 12387  tu つ 12388  du づ 12389  te て 12390  de で 12391  to と 12392  do ど 12393
na な 12394  ni に 12395  nu ぬ 12396  ne ね 12397  no の 12398  ha は 12399  ba ば 12400
pa ぱ 12401  hi ひ 12402  bi び 12403  pi ぴ 12404  hu ふ 12405  bu ぶ 12406  pu ぷ 12407
he へ 12408  be べ 12409  pe ぺ 12410  ho ほ 12411  bo ぼ 12412  po ぽ 12413  ma ま 12414
mi み 12415  mu む 12416  me め 12417  mo も 12418  yA ゃ 12419  ya や 12420  yU ゅ 12421
yu ゆ 12422  yO ょ 12423  yo よ 12424  ra ら 12425  ri り 12426  ru る 12427  re れ 12428
ro ろ 12429  wA ゎ 12430  wa わ 12431  wi ゐ 12432  we ゑ 12433  wo を 12434  n5 ん 12435
vu ゔ 12436  "5 ゛ 12443  05 ゜ 12444  *5 ゝ 12445  +5 ゞ 12446  a6 ァ 12449  A6 ア 12450
i6 ィ 12451  I6 イ 12452  u6 ゥ 12453  U6 ウ 12454  e6 ェ 12455  E6 エ 12456  o6 ォ 12457
O6 オ 12458  Ka カ 12459  Ga ガ 12460  Ki キ 12461  Gi ギ 12462  Ku ク 12463  Gu グ 12464
Ke ケ 12465  Ge ゲ 12466  Ko コ 12467  Go ゴ 12468  Sa サ 12469  Za ザ 12470  Si シ 12471
Zi ジ 12472  Su ス 12473  Zu ズ 12474  Se セ 12475  Ze ゼ 12476  So ソ 12477  Zo ゾ 12478
Ta タ 12479  Da ダ 12480  Ti チ 12481  Di ヂ 12482  TU ッ 12483  Tu ツ 12484  Du ヅ 12485
Te テ 12486  De デ 12487  To ト 12488  Do ド 12489  Na ナ 12490  Ni ニ 12491  Nu ヌ 12492
Ne ネ 12493  No ノ 12494  Ha ハ 12495  Ba バ 12496  Pa パ 12497  Hi ヒ 12498  Bi ビ 12499
Pi ピ 12500  Hu フ 12501  Bu ブ 12502  Pu プ 12503  He ヘ 12504  Be ベ 12505  Pe ペ 12506
Ho ホ 12507  Bo ボ 12508  Po ポ 12509  Ma マ 12510  Mi ミ 12511  Mu ム 12512  Me メ 12513
Mo モ 12514  YA ャ 12515  Ya ヤ 12516  YU ュ 12517  Yu ユ 12518  YO ョ 12519  Yo ヨ 12520
Ra ラ 12521  Ri リ 12522  Ru ル 12523  Re レ 12524  Ro ロ 12525  WA ヮ 12526  Wa ワ 12527
Wi ヰ 12528  We ヱ 12529  Wo ヲ 12530  N6 ン 12531  Vu ヴ 12532  KA ヵ 12533  KE ヶ 12534
Va ヷ 12535  Vi ヸ 12536  Ve ヹ 12537  Vo ヺ 12538  .6 ・ 12539  -6 ー 12540  *6 ヽ 12541
+6 ヾ 12542  b4 ㄅ 12549  p4 ㄆ 12550  m4 ㄇ 12551  f4 ㄈ 12552  d4 ㄉ 12553  t4 ㄊ 12554
n4 ㄋ 12555  l4 ㄌ 12556  g4 ㄍ 12557  k4 ㄎ 12558  h4 ㄏ 12559  j4 ㄐ 12560  q4 ㄑ 12561
x4 ㄒ 12562  zh ㄓ 12563  ch ㄔ 12564  sh ㄕ 12565  r4 ㄖ 12566  z4 ㄗ 12567  c4 ㄘ 12568
s4 ㄙ 12569  a4 ㄚ 12570  o4 ㄛ 12571  e4 ㄜ 12572  ai ㄞ 12574  ei ㄟ 12575  au ㄠ 12576
ou ㄡ 12577  an ㄢ 12578  en ㄣ 12579  aN ㄤ 12580  eN ㄥ 12581  er ㄦ 12582  i4 ㄧ 12583
u4 ㄨ 12584  iu ㄩ 12585  v4 ㄪ 12586  nG ㄫ 12587  gn ㄬ 12588  1c ㈠ 12832  2c ㈡ 12833
3c ㈢ 12834  4c ㈣ 12835  5c ㈤ 12836  6c ㈥ 12837  7c ㈦ 12838  8c ㈧ 12839  9c ㈨ 12840
ff ﬀ  64256  fi ﬁ  64257  fl ﬂ  64258  ft ﬅ  64261  st ﬆ  64262
```



