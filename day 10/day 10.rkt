#lang racket
(define opening-brackets (string->list"{[<("))
(define closing-brackets (string->list"}]>)"))
(define corrupted-points (list 1197 57 25137 3))
(define incomplete-points (list 3 2 4 1))

(define in_f (open-input-file "day 10.txt" #:mode'text) )

(define lines (sequence->list (in-lines in_f) ))
(define (score-incomplete stack chars)
  (if (empty? chars)
      (score-incomplete+ stack 0)
      (if (member (first chars) opening-brackets)
          (score-incomplete (cons (first chars) stack) (rest chars))
          (score-incomplete (rest stack) (rest chars))
          )
      )
  )
(define (score-incomplete+ stack score)
  (if (empty? stack)
      score
      (score-incomplete+ (rest stack) ( + (* score 5)(list-ref incomplete-points (index-of opening-brackets (first stack))))))
  )
(define (score-corrupted stack chars)
  (if (empty? chars)
      0
      (if (member (first chars) opening-brackets)
          (score-corrupted (cons (first chars) stack) (rest chars))
          (if (= (index-of opening-brackets (first stack)) (index-of closing-brackets (first chars)))
               (score-corrupted (rest stack) (rest chars))
              (list-ref corrupted-points (index-of closing-brackets (first chars)))
              )
          )
      )
  )
(define scores-corrupted (map (curry score-corrupted empty) (map string->list lines)))
(display (foldl + 0 scores-corrupted))
(define lines-incomplete (for/list (
           [i (in-range (length scores-corrupted))]
           #:when (= (list-ref scores-corrupted i) 0)
           )
  (list-ref lines i)
  ))
(define scores-incomplete (map (curry score-incomplete empty) (map string->list lines-incomplete)))
(display "\n")
(display (list-ref (sort scores-incomplete <) (floor (/ (length scores-incomplete) 2))))


