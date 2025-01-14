function task_watch --wraps='ls task.sh | entr "./task.sh"' --wraps='z scriptsts && ls task.sh | entr "./task.sh"' --description 'alias task_watch z scriptsts && ls task.sh | entr "./task.sh"'
  z scriptsts && ls task.sh | entr "./task.sh" $argv
        
end
