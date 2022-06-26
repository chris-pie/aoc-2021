use std::fs::File;
use std::io::Read;
use std::collections::HashSet;
use std::cmp;
use std::convert::TryInto;

fn main() 
{
    let mut file_in = File::open("day 13.txt").expect("Can't open");
    let mut in_str = String::new();
    file_in.read_to_string(&mut in_str).expect("Can't read");
    let mut split_in_str = in_str.trim().split("\n\n");
    let points = split_in_str.next().unwrap();
    let folds = split_in_str.next().unwrap();
    let mut point_set = HashSet::new();
    for point in points.split("\n")
    {
        let mut point_split = point.trim().split(",");
        let x = point_split.next().unwrap();
        let y = point_split.next().unwrap();
        point_set.insert((x.parse::<i32>().unwrap(), y.parse::<i32>().unwrap()));

    }
    let mut fold_list: Vec<(String, i32)> = Vec::new();
    for fold in folds.split("\n")
    {
        let mut fold_trim = fold.trim().chars();
        let axis = fold_trim.nth(11).unwrap();
        let value: String = fold_trim.skip(1).collect();
        fold_list.push((axis.to_string(), value.parse::<i32>().unwrap()));

    }
    let mut show_answer = true;
    for fold in &fold_list
    {
        let mut new_point_set = HashSet::new();
        for point in point_set
        {
            let new_point =
            if fold.0 == "x"
            {
                (point.0 - cmp::max((point.0 - fold.1) * 2, 0), point.1)
            }
            else
            {
                (point.0, (point.1 - cmp::max((point.1 - fold.1) * 2, 0)))
            };
            new_point_set.insert(new_point);
        }
        if show_answer
        {
            println!("{}", new_point_set.len());
            show_answer = false;
        }
        point_set = new_point_set;
    }

    let mut max_x = 0;
    let mut max_y = 0;
    for point in &point_set
    {
        max_x = cmp::max(max_x, point.0 + 1);
        max_y = cmp::max(max_y, point.1 + 1);
    }
    let mut output_grid = vec![vec![" "; max_x.try_into().unwrap()]; max_y.try_into().unwrap()];
    for point in point_set
    {
        output_grid[point.1 as usize][point.0 as usize] = "■";
    }
    for line in output_grid
    {
        for char_ in line
        {
            print!("{}", char_);
        }
        println!();
    }
}

