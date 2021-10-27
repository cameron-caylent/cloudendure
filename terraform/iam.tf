resource "aws_iam_policy" "iam-policy" {
  name   = "AWS-CloudEndure"
  path   = "/"
#  policy = data.aws_iam_policy_document.iam-policy-document.json
  assume_role_policy = file("./ce-iam.json")
  tags = {
    Client = "wine.com"
  }

}

# data "aws_iam_policy_document" "iam-policy-document" {
  # insert cloudendure policy here

# }

resource "aws_iam_user" "iam-user" {
  name = "cloudendure-user"
  path = "/"

  tags = {
    Client = "wine.com"
  }
}

resource "aws_iam_user_policy" "iam-user-policy" {
  name   = "cloudendure-user-policy"
  user   = aws_iam_user.iam-user.name
  policy = aws_iam_policy.iam-policy.policy
}

resource "aws_iam_access_key" "iam-user-key" {
  user = aws_iam_user.iam-user.name

}

output "id" {
  value = aws_iam_access_key.iam-user-key.id
}

output "secret" {
  value     = aws_iam_access_key.iam-user-key.secret
  sensitive = true
}
