require 'spec_helper'

describe Boards::CreateService, services: true do
  describe '#execute' do
    let(:project) { create(:empty_project) }

    subject(:service) { described_class.new(project, double) }

    context 'when project does not have a board' do
      it 'creates a new board' do
        expect { service.execute }.to change(Board, :count).by(1)
      end

      it 'creates default lists' do
        board = service.execute

        expect(board.lists.size).to eq 2
        expect(board.lists.first).to be_backlog
        expect(board.lists.last).to be_done
      end
    end

    context 'when project has a board' do
      before do
        create(:board, project: project)
      end

      it 'does not create a new board' do
        expect { service.execute }.not_to change(project.boards, :count)
      end
    end
  end
end
