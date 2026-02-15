puts "== Criando usuário de teste =="
user = User.find_or_create_by!(email: "admin@vagas.com") do |u|
  u.password = "123456"
  u.password_confirmation = "123456"
end
puts "   Email: #{user.email} | Senha: 123456"

puts "\n== Criando vagas =="

jobs_data = [
  {
    title: "Desenvolvedor(a) Ruby on Rails",
    description: "Buscamos um(a) dev backend com experiência sólida em Ruby on Rails, PostgreSQL e arquitetura de APIs RESTful. Atuará no desenvolvimento de novas features e manutenção de sistemas internos.",
    status: "published",
    location: "Remoto",
    employment_type: "clt"
  },
  {
    title: "Front-end Developer Vue.js",
    description: "Vaga para desenvolvedor(a) front-end com domínio de Vue.js 3, Nuxt.js e TypeScript. Participará da construção de interfaces ricas e acessíveis para nossos produtos digitais.",
    status: "published",
    location: "São Paulo - SP",
    employment_type: "clt"
  },
  {
    title: "Fullstack Developer Node.js + React",
    description: "Procuramos profissional fullstack para atuar com Node.js no back-end e React no front-end. Experiência com AWS e CI/CD é um diferencial importante para a posição.",
    status: "published",
    location: "Remoto",
    employment_type: "pj"
  },
  {
    title: "Mobile Developer React Native",
    description: "Oportunidade para dev mobile com experiência em React Native e publicação de apps nas lojas. Atuará em projeto greenfield de aplicativo para o mercado financeiro.",
    status: "published",
    location: "Belo Horizonte - MG",
    employment_type: "clt"
  },
  {
    title: "Estagiário(a) de Desenvolvimento",
    description: "Estágio em desenvolvimento de software para estudantes de Ciência da Computação ou áreas afins. Terá mentoria técnica e atuará em projetos reais com a equipe de engenharia.",
    status: "published",
    location: "Curitiba - PR",
    employment_type: "internship"
  },
  {
    title: "DevOps Engineer",
    description: "Buscamos engenheiro(a) DevOps para gerenciar infraestrutura cloud (AWS/GCP), pipelines CI/CD e observabilidade. Experiência com Kubernetes e Terraform é essencial.",
    status: "draft",
    location: "Remoto",
    employment_type: "pj"
  },
  {
    title: "Tech Lead Backend",
    description: "Posição de liderança técnica para coordenar o time de backend. Responsável por decisões de arquitetura, code reviews e mentoria de desenvolvedores juniores e plenos.",
    status: "draft",
    location: "Rio de Janeiro - RJ",
    employment_type: "clt"
  },
  {
    title: "QA Analyst",
    description: "Analista de qualidade para atuar com testes automatizados (Cypress, RSpec) e manuais. Participará da definição de estratégias de teste e garantia de qualidade do produto.",
    status: "draft",
    location: nil,
    employment_type: nil
  }
]

jobs_data.each do |data|
  job = Job.find_or_create_by!(title: data[:title]) do |j|
    j.description = data[:description]
    j.status = data[:status]
    j.location = data[:location]
    j.employment_type = data[:employment_type]
  end
  puts "   [#{job.status.upcase.ljust(9)}] #{job.title}"
end

puts "\n== Seeds finalizadas! =="
puts "   Usuários: #{User.count}"
puts "   Vagas: #{Job.count} (#{Job.where(status: 'published').count} published, #{Job.where(status: 'draft').count} draft)"
