#!/bin/bash
# SPDX-FileCopyrightText: 2026 Shunsuke Shibata <s23C1068BM@chibatech.ac.jp>
# SPDX-License-Identifier: BSD-3-Clause

ng () {                               # 関数ngの定義（P18と同じ）
        echo ${1}行目のテスト失敗
        res=1                          # 失敗したことを記録
}

res=0                                  # 0: 失敗なし（ngが呼ばれると1になる）

### NORMAL INPUT ###
out=$(seq 5 | ./plus_stdin)
[ "$?" = 0 ]      || ng "$LINENO"
[ "${out}" = 15 ] || ng "$LINENO"

### STRANGE INPUT ###
out=$(echo あ | ./plus_stdin)           #計算できない値を入力してみる
[ "$?" = 1 ]      || ng "$LINENO" #終了ステータスが1なのを確認
[ "${out}" = "" ] || ng "$LINENO" #上の行と入れ替えるとダメ（なぜ？）

out=$(echo | ./plus_stdin)              #なにも入力しない
[ "$?" = 1 ]      || ng "$LINENO" #これも異常終了する
[ "${out}" = "" ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
