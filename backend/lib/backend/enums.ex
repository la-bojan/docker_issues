import EctoEnum

defenum(Backend.PermissionType, :permission_type, [
  :manage,
  :write,
  :read
])

defenum(Backend.TaskStatus, :status, [
  :not_started,
  :in_progress,
  :for_review,
  :blocked,
  :done
])
